import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/constants/app_constants.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// ⚔️ Duel Screen — voice battle: record → STT → score
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class DuelScreen extends ConsumerStatefulWidget {
  const DuelScreen({super.key});

  @override
  ConsumerState<DuelScreen> createState() => _DuelScreenState();
}

class _DuelScreenState extends ConsumerState<DuelScreen> {
  int _round = 1;
  int _timer = DuelConfig.turnDuration;
  bool _recording = false;
  String _phase = 'ready'; // ready, speaking, botTurn, transition
  final List<_Message> _messages = [];
  int _userScore = 0;
  int _botScore = 0;
  Timer? _timerInterval;
  final _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _startRound();
  }

  @override
  void dispose() {
    _timerInterval?.cancel();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _startRound() {
    setState(() => _phase = 'ready');
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      setState(() => _phase = 'speaking');
      _startTimer();
    });
  }

  void _startTimer() {
    _timer = DuelConfig.turnDuration;
    _timerInterval?.cancel();
    _timerInterval = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _timer--);
      if (_timer <= 0 && _recording) _stopRecording();
    });
  }

  void _startRecording() {
    // In production: ref.read(audioServiceProvider).startRecording()
    setState(() => _recording = true);
  }

  void _stopRecording() {
    setState(() => _recording = false);
    _timerInterval?.cancel();

    // Simulate user message (in production: STT → text)
    final userTexts = [
      'I really enjoy playing basketball on weekends. It helps me stay healthy and I love the teamwork.',
      'Another thing I like is reading books, especially science fiction novels about space exploration.',
      'I also spend time learning new programming languages because technology fascinates me a lot.',
    ];

    _addMessage(_Message(
      sender: 'user',
      text: userTexts[(_round - 1) % userTexts.length],
    ));

    setState(() => _phase = 'botTurn');

    // Simulate bot reply (in production: DeepSeek API)
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;

      final botTexts = [
        'That sounds wonderful! Basketball is great for both fitness and building social connections. How often do you play?',
        'Science fiction is fascinating! Have you read any books by Isaac Asimov? His Foundation series is remarkable.',
        'Programming is a valuable skill! Which language are you currently learning?',
      ];

      _addMessage(_Message(
        sender: 'bot',
        text: botTexts[(_round - 1) % botTexts.length],
      ));

      // Score this round
      final roundUserScore = 20 + (DateTime.now().millisecond % 8);
      final roundBotScore = 18 + (DateTime.now().millisecond % 6);
      setState(() {
        _userScore += roundUserScore;
        _botScore += roundBotScore;
      });

      if (_round < DuelConfig.roundCount) {
        setState(() => _phase = 'transition');
        Future.delayed(const Duration(milliseconds: 1500), () {
          if (!mounted) return;
          setState(() {
            _round++;
            _timer = DuelConfig.turnDuration;
          });
          _startRound();
        });
      } else {
        // Duel finished → navigate to result
        Future.delayed(const Duration(seconds: 1), () {
          if (!mounted) return;
          ref.read(currentUserProvider.notifier).recordDuel(
                won: _userScore > _botScore,
              );
          ref.read(duelUserScoreProvider.notifier).state = _userScore;
          ref.read(duelBotScoreProvider.notifier).state = _botScore;
          context.pushReplacement(AppRoutes.result);
        });
      }
    });
  }

  void _addMessage(_Message msg) {
    setState(() => _messages.add(msg));
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollCtrl.animateTo(
        _scrollCtrl.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final topic = ref.watch(selectedTopicProvider);

    return Scaffold(
      body: Column(
        children: [
          // ── Top Bar ──
          _DuelTopBar(
            round: _round,
            userScore: _userScore,
            botScore: _botScore,
          ),

          // ── Topic Banner ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: AppColors.accent.withOpacity(0.1),
            child: Text(
              '🎯 Topic: "${topic?.prompt ?? "Tell me about your favorite hobby"}"',
              style: AppText.bodySm.copyWith(
                color: AppColors.dark,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // ── Chat Area ──
          Expanded(
            child: ListView.builder(
              controller: _scrollCtrl,
              padding: const EdgeInsets.all(AppSpacing.base),
              itemCount: _messages.length + (_phase == 'ready' ? 1 : 0) +
                  (_phase == 'botTurn' && _messages.length % 2 == 1 ? 1 : 0) +
                  (_phase == 'transition' ? 1 : 0),
              itemBuilder: (_, i) {
                if (_phase == 'ready' && i == 0) {
                  return _RoundBanner(round: _round);
                }

                final msgIndex = _phase == 'ready' ? i - 1 : i;

                if (msgIndex < _messages.length) {
                  return _ChatBubble(message: _messages[msgIndex]);
                }

                if (_phase == 'botTurn') return const _TypingIndicator();
                if (_phase == 'transition') {
                  return Center(
                    child: AppBadge(
                      text: 'Round $_round дууслаа!',
                      color: AppColors.secondary.withOpacity(0.15),
                      textColor: AppColors.secondary,
                    ),
                  );
                }

                return const SizedBox.shrink();
              },
            ),
          ),

          // ── Bottom Controls ──
          _BottomControls(
            phase: _phase,
            timer: _timer,
            recording: _recording,
            onStartRecord: _startRecording,
            onStopRecord: _stopRecording,
          ),
        ],
      ),
    );
  }
}

// ── Message model (screen-local) ─────────────────────
class _Message {
  const _Message({required this.sender, required this.text});
  final String sender;
  final String text;
}

// ── Top Bar ──────────────────────────────────────────
class _DuelTopBar extends StatelessWidget {
  const _DuelTopBar({
    required this.round,
    required this.userScore,
    required this.botScore,
  });

  final int round;
  final int userScore;
  final int botScore;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 8,
        left: 16,
        right: 16,
        bottom: 12,
      ),
      child: Column(
        children: [
          // Players row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const AppAvatar(size: 30, emoji: '😎', color: AppColors.accent, borderWidth: 2),
                  const SizedBox(width: 8),
                  Text('You', style: AppText.headingSm.copyWith(color: AppColors.white, fontSize: 13)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  'Round $round/${DuelConfig.roundCount}',
                  style: AppText.headingSm.copyWith(color: AppColors.white, fontSize: 13),
                ),
              ),
              Row(
                children: [
                  Text('Bot', style: AppText.headingSm.copyWith(color: AppColors.white, fontSize: 13)),
                  const SizedBox(width: 8),
                  const AppAvatar(size: 30, emoji: '🤖', color: AppColors.secondary, borderWidth: 2),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          // Score row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$userScore',
                style: AppText.displaySm.copyWith(color: AppColors.accent),
              ),
              Text(
                '⚡ VS ⚡',
                style: AppText.bodySm.copyWith(color: Colors.white54),
              ),
              Text(
                '$botScore',
                style: AppText.displaySm.copyWith(color: AppColors.accent),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Round Banner ─────────────────────────────────────
class _RoundBanner extends StatelessWidget {
  const _RoundBanner({required this.round});
  final int round;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Column(
        children: [
          const Text('🎙️', style: TextStyle(fontSize: 36)),
          const SizedBox(height: 8),
          Text(
            'Round $round — Бэлэн бол!',
            style: AppText.displaySm.copyWith(color: AppColors.primary),
          ),
        ],
      ),
    );
  }
}

// ── Chat Bubble ──────────────────────────────────────
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});
  final _Message message;

  bool get isUser => message.sender == 'user';

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.78,
          ),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: isUser ? AppColors.primaryGradient : null,
            color: isUser ? null : AppColors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: (isUser ? AppColors.primary : Colors.black).withOpacity(isUser ? 0.2 : 0.04),
                blurRadius: 12,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isUser ? '🎙️ Voice → Text' : '🤖 Bot',
                style: AppText.label.copyWith(
                  color: isUser ? Colors.white60 : AppColors.darkSoft,
                  fontSize: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                message.text,
                style: AppText.bodyMd.copyWith(
                  color: isUser ? AppColors.white : AppColors.dark,
                  height: 1.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Typing Indicator ─────────────────────────────────
class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (i) {
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 600 + i * 200),
              builder: (_, val, child) => Transform.translate(
                offset: Offset(0, -4 * val),
                child: child,
              ),
              child: Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(horizontal: 2),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.darkSoft,
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ── Bottom Controls (Mic Button + Timer) ─────────────
class _BottomControls extends StatelessWidget {
  const _BottomControls({
    required this.phase,
    required this.timer,
    required this.recording,
    required this.onStartRecord,
    required this.onStopRecord,
  });

  final String phase;
  final int timer;
  final bool recording;
  final VoidCallback onStartRecord;
  final VoidCallback onStopRecord;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.light)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (phase == 'speaking') ...[
            Text(
              '⏱️ ${timer}s үлдсэн',
              style: AppText.headingSm.copyWith(
                color: timer <= 5 ? AppColors.danger : AppColors.darkSoft,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: recording ? onStopRecord : onStartRecord,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: recording
                      ? AppColors.dangerGradient
                      : AppColors.primaryGradient,
                  boxShadow: [
                    BoxShadow(
                      color: (recording ? AppColors.danger : AppColors.primary)
                          .withOpacity(0.35),
                      blurRadius: recording ? 24 : 16,
                      spreadRadius: recording ? 4 : 0,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Icon(
                  recording ? Icons.stop_rounded : Icons.mic_rounded,
                  color: AppColors.white,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              recording ? '🔴 Ярьж байна... Дарж зогсоо' : 'Дарж ярь',
              style: AppText.bodySm,
            ),
          ],
          if (phase == 'botTurn')
            Text(
              '🤖 Bot хариулж байна...',
              style: AppText.headingSm.copyWith(
                color: AppColors.secondary,
                fontSize: 13,
              ),
            ),
        ],
      ),
    );
  }
}
