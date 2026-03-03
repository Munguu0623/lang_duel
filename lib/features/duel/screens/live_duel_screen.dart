import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/motion/motion.dart';
import '../../../core/theme/tokens.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/soft_card.dart';
import '../../../ui/widgets/top_bar.dart';

class LiveDuelScreen extends StatefulWidget {
  const LiveDuelScreen({
    super.key,
    required this.opponent,
    required this.prompt,
    required this.durationSeconds,
    required this.onTimeUp,
  });

  final DuelUser opponent;
  final String prompt;
  final int durationSeconds;
  final VoidCallback onTimeUp;

  @override
  State<LiveDuelScreen> createState() => _LiveDuelScreenState();
}

class _LiveDuelScreenState extends State<LiveDuelScreen> {
  late int _remaining;
  Timer? _countdownTimer;
  Timer? _transcriptTimer;
  final _transcriptLines = <String>[];
  bool _isRecording = false;
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _remaining = widget.durationSeconds;

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        timer.cancel();
        widget.onTimeUp();
      }
    });

    // Fake transcript lines appear periodically.
    _transcriptTimer =
        Timer.periodic(const Duration(milliseconds: 2500), (timer) {
      if (_transcriptLines.length < FakeData.fakeTranscriptLines.length) {
        setState(() {
          _transcriptLines
              .add(FakeData.fakeTranscriptLines[_transcriptLines.length]);
        });
        Future.delayed(const Duration(milliseconds: 100), () {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: DurationTokens.normal,
              curve: Curves.easeOut,
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _transcriptTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  String get _formattedTime {
    final min = _remaining ~/ 60;
    final sec = _remaining % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isLowTime = _remaining <= 10;

    return SafeArea(
      child: Column(
        children: [
          const TopBar(title: 'Live duel'),
          const SizedBox(height: SpacingTokens.sm),
          // Opponent header
          Padding(
            padding: const EdgeInsets.all(SpacingTokens.base),
            child: Row(
              children: [
                DuelAvatar(name: widget.opponent.name, size: 40),
                const SizedBox(width: SpacingTokens.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.opponent.name,
                          style: Theme.of(context).textTheme.titleMedium),
                      Text(
                        '${widget.opponent.rank} • ${widget.opponent.rating}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
                _LiveBadge(),
              ],
            ),
          ),

          // Timer — AnimatedSwitcher per tick for subtle cross-fade.
          AnimatedSwitcher(
            duration: DurationTokens.normal,
            child: Text(
              _formattedTime,
              key: ValueKey(_remaining),
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.w800,
                color: isLowTime ? c.danger : c.textPrimary,
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.base),

          // Prompt card
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
            child: SoftCard(
              child: Column(
                children: [
                  Text('Topic',
                      style: Theme.of(context).textTheme.bodyMedium),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    widget.prompt,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.base),

          // Live transcript
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
              child: RepaintBoundary(
                child: _TranscriptCard(
                  controller: _scrollController,
                  lines: _transcriptLines,
                ),
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.base),

          // Mic button — subtle scale + glow.
          GestureDetector(
            onTapDown: (_) => setState(() => _isRecording = true),
            onTapUp: (_) => setState(() => _isRecording = false),
            onTapCancel: () => setState(() => _isRecording = false),
            child: AnimatedScale(
              scale: _isRecording ? 1.03 : 1.0,
              duration: MotionDurations.fast,
              curve: MotionCurves.standard,
              child: AnimatedContainer(
                duration: MotionDurations.fast,
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: _isRecording ? c.danger : c.primary,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: (_isRecording ? c.danger : c.primary)
                          .withValues(alpha: _isRecording ? 0.35 : 0.24),
                      blurRadius: _isRecording ? 18 : 14,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: Colors.white,
                  size: 32,
                ),
              ),
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),
        ],
      ),
    );
  }
}

class _TranscriptCard extends StatelessWidget {
  const _TranscriptCard({
    required this.controller,
    required this.lines,
  });

  final ScrollController controller;
  final List<String> lines;

  @override
  Widget build(BuildContext context) {
    return SoftCard(
      padding: const EdgeInsets.all(SpacingTokens.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Live Transcript',
              style: Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: SpacingTokens.sm),
          Expanded(
            child: ListView.builder(
              controller: controller,
              itemCount: lines.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: SpacingTokens.xs),
                  child: Text(
                    lines[index],
                    style: TextStyles.bodyLarge,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _LiveBadge extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: c.danger.withValues(alpha: 0.1),
        borderRadius: RadiusTokens.small,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: c.danger,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            'LIVE',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: c.danger,
            ),
          ),
        ],
      ),
    );
  }
}
