import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_service.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../data/chat_message.dart';
import '../data/duel_models.dart';
import '../data/duel_repository.dart';
import '../services/transcription_service.dart';
import '../services/voice_recorder_service.dart';

class LiveDuelScreen extends StatefulWidget {
  const LiveDuelScreen({
    super.key,
    required this.opponent,
    required this.prompt,
    required this.matchId,
    required this.currentUserId,
    required this.durationSeconds,
    required this.onTimeUp,
  });

  final DuelUser opponent;
  final String prompt;
  final String matchId;
  final String currentUserId;
  final int durationSeconds;
  final VoidCallback onTimeUp;

  @override
  State<LiveDuelScreen> createState() => _LiveDuelScreenState();
}

class _LiveDuelScreenState extends State<LiveDuelScreen> {
  // ─── Countdown ───────────────────────────────────────────────
  late int _remaining;
  Timer? _countdownTimer;

  // ─── Chat ────────────────────────────────────────────────────
  final List<ChatMessage> _messages = [];
  final _scrollController = ScrollController();

  // ─── Recording ───────────────────────────────────────────────
  bool _isRecording = false;
  bool _isSending = false;
  Duration _recordingDuration = Duration.zero;
  Timer? _recordingTimer;
  Timer? _waveformTimer;
  List<double> _waveformBars = List.filled(24, 0.15);
  final _recorder = VoiceRecorderService();
  final _transcription = TranscriptionService();

  // ─── Repo + polling ──────────────────────────────────────────
  late final DuelRepository _duelRepo;
  int _lastSeq = 0;
  Timer? _pollTimer;

  static final _random = Random();

  // ─── Init ────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _remaining = widget.durationSeconds;
    _duelRepo = DuelRepository(ApiClient(bearerToken: authService.token));

    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) return;
      if (_remaining > 0) {
        setState(() => _remaining--);
      } else {
        t.cancel();
        widget.onTimeUp();
      }
    });

    // Human match: 2s polling for opponent messages.
    // Bot replies come back synchronously from POST /duel/chat.
    if (widget.opponent.rank != 'BOT') {
      _pollTimer = Timer.periodic(
        const Duration(seconds: 2),
        (_) => _pollOpponentMessages(),
      );
    }
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    _pollTimer?.cancel();
    _scrollController.dispose();
    _recorder.dispose();
    super.dispose();
  }

  // ─── Helpers ─────────────────────────────────────────────────

  String get _formattedTime {
    final min = _remaining ~/ 60;
    final sec = _remaining % 60;
    return '${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}';
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _addMessage(ChatMessage msg) {
    setState(() => _messages.add(msg));
    _scrollToBottom();
  }

  void _replaceMessage(String id, ChatMessage replacement) {
    setState(() {
      final idx = _messages.indexWhere((m) => m.id == id);
      if (idx != -1) _messages[idx] = replacement;
    });
    _scrollToBottom();
  }

  // ─── Opponent polling ─────────────────────────────────────────

  Future<void> _pollOpponentMessages() async {
    if (!mounted) return;
    try {
      final msgs = await _duelRepo.pollMessages(widget.matchId, after: _lastSeq);
      if (!mounted || msgs.isEmpty) return;
      for (final msg in msgs) {
        if (msg.userId != widget.currentUserId) {
          _addMessage(ChatMessage(
            id: 'remote_${msg.seq}',
            text: msg.transcript,
            isMe: false,
            timestamp: DateTime.now(),
          ));
        }
        if (msg.seq > _lastSeq) _lastSeq = msg.seq;
      }
    } catch (_) {
      // Network error — retry on next tick.
    }
  }

  // ─── Recording ───────────────────────────────────────────────

  Future<void> _startRecording() async {
    if (_isSending) return;
    final started = await _recorder.start();
    if (!started || !mounted) return;

    setState(() {
      _isRecording = true;
      _recordingDuration = Duration.zero;
      _waveformBars = List.filled(24, 0.15);
    });

    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _recordingDuration += const Duration(seconds: 1));
    });

    _waveformTimer = Timer.periodic(const Duration(milliseconds: 80), (_) {
      if (!mounted) return;
      setState(() {
        _waveformBars = List.generate(24, (_) => 0.1 + _random.nextDouble() * 0.9);
      });
    });
  }

  Future<void> _stopAndSend() async {
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();

    final audioBytes = await _recorder.stop();
    if (!mounted) return;

    setState(() {
      _isRecording = false;
      _isSending = true;
    });

    if (audioBytes == null) {
      setState(() => _isSending = false);
      return;
    }

    // Optimistic loading bubble
    final msgId = 'me_${DateTime.now().millisecondsSinceEpoch}';
    _addMessage(ChatMessage(
      id: msgId,
      text: '',
      isMe: true,
      timestamp: DateTime.now(),
      isLoading: true,
    ));

    // POST /duel/chat — Whisper + optional bot reply
    final result = await _transcription.sendMessage(
      audioBytes,
      mimeType: _recorder.mimeType,
      matchId: widget.matchId,
      durationMs: _recordingDuration.inMilliseconds,
      repo: _duelRepo,
    );
    if (!mounted) return;

    _replaceMessage(
      msgId,
      ChatMessage(
        id: msgId,
        text: result.transcript,
        isMe: true,
        timestamp: DateTime.now(),
      ),
    );

    // Advance polling cursor to skip own message
    if (result.seq > _lastSeq) _lastSeq = result.seq;

    setState(() => _isSending = false);

    // Bot match: show GPT reply with typing animation
    if (result.botReply != null) {
      _showBotReply(result.botReply!);
    }
  }

  Future<void> _cancelRecording() async {
    _recordingTimer?.cancel();
    _waveformTimer?.cancel();
    await _recorder.cancel();
    if (!mounted) return;
    setState(() => _isRecording = false);
  }

  /// Shows bot reply: typing indicator first, then text after delay.
  void _showBotReply(BotChatReply reply) {
    final loadingId = 'bot_${DateTime.now().millisecondsSinceEpoch}';
    _addMessage(ChatMessage(
      id: loadingId,
      text: '',
      isMe: false,
      timestamp: DateTime.now(),
      isLoading: true,
    ));

    final delay = reply.durationMs.clamp(1200, 3500);
    Future.delayed(Duration(milliseconds: delay), () {
      if (!mounted) return;
      _replaceMessage(
        loadingId,
        ChatMessage(
          id: loadingId,
          text: reply.text,
          isMe: false,
          timestamp: DateTime.now(),
        ),
      );
    });
  }

  // ─── Build ────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isLowTime = _remaining <= 10;

    return Scaffold(
      backgroundColor: c.background,
      body: SafeArea(
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────────
            _Header(
              opponent: widget.opponent,
              remaining: _remaining,
              formattedTime: _formattedTime,
              isLowTime: isLowTime,
            ),

            // ── Topic bar ────────────────────────────────────────
            _TopicBar(prompt: widget.prompt),

            // ── Chat messages ────────────────────────────────────
            Expanded(
              child: _messages.isEmpty
                  ? _EmptyState(opponentName: widget.opponent.name)
                  : ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.symmetric(
                        horizontal: SpacingTokens.base,
                        vertical: SpacingTokens.md,
                      ),
                      itemCount: _messages.length,
                      itemBuilder: (ctx, i) => _Bubble(
                        message: _messages[i],
                        senderName: _messages[i].isMe
                            ? 'You'
                            : widget.opponent.name,
                        showSender: i == 0 ||
                            _messages[i].isMe != _messages[i - 1].isMe,
                      ),
                    ),
            ),

            // ── Input bar ────────────────────────────────────────
            _InputBar(
              isRecording: _isRecording,
              isSending: _isSending,
              duration: _recordingDuration,
              bars: _waveformBars,
              onMicTap: _startRecording,
              onSend: _stopAndSend,
              onDelete: _cancelRecording,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Header
// ─────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({
    required this.opponent,
    required this.remaining,
    required this.formattedTime,
    required this.isLowTime,
  });

  final DuelUser opponent;
  final int remaining;
  final String formattedTime;
  final bool isLowTime;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(bottom: BorderSide(color: c.border, width: 1)),
      ),
      child: Row(
        children: [
          // Opponent info
          DuelAvatar(name: opponent.name, size: 38),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  opponent.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: c.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Live',
                      style: TextStyle(
                        fontSize: 12,
                        color: c.success,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Timer pill
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: isLowTime
                  ? c.danger.withValues(alpha: 0.12)
                  : c.primaryLight,
              borderRadius: RadiusTokens.pill,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.timer_rounded,
                  size: 14,
                  color: isLowTime ? c.danger : c.primary,
                ),
                const SizedBox(width: 4),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: Text(
                    formattedTime,
                    key: ValueKey(formattedTime),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: isLowTime ? c.danger : c.primary,
                      fontFeatures: const [FontFeature.tabularFigures()],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Topic bar
// ─────────────────────────────────────────────────────────────

class _TopicBar extends StatelessWidget {
  const _TopicBar({required this.prompt});
  final String prompt;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: c.accent.withValues(alpha: 0.06),
        border: Border(
          bottom: BorderSide(color: c.border, width: 1),
          left: BorderSide(color: c.accent, width: 3),
        ),
      ),
      child: Row(
        children: [
          Icon(Icons.lightbulb_outline_rounded, size: 14, color: c.accent),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              prompt,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: c.accent,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Empty state
// ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.opponentName});
  final String opponentName;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: c.primaryLight,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.mic_none_rounded, size: 32, color: c.primary),
          ),
          const SizedBox(height: SpacingTokens.base),
          Text(
            'Tap the mic to start speaking',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            'Your voice will be converted to text\nand shared with $opponentName',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 13, color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Chat bubble
// ─────────────────────────────────────────────────────────────

class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.message,
    required this.senderName,
    required this.showSender,
  });

  final ChatMessage message;
  final String senderName;
  final bool showSender;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final isMe = message.isMe;

    return Padding(
      padding: EdgeInsets.only(
        bottom: SpacingTokens.xs,
        top: showSender ? SpacingTokens.md : 0,
      ),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          if (showSender)
            Padding(
              padding: EdgeInsets.only(
                left: isMe ? 0 : SpacingTokens.xs,
                right: isMe ? SpacingTokens.xs : 0,
                bottom: 4,
              ),
              child: Text(
                senderName,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: isMe ? c.primary : c.textSecondary,
                ),
              ),
            ),
          Align(
            alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.75,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isMe ? c.primary : c.surface,
                  borderRadius: BorderRadius.only(
                    topLeft: const Radius.circular(18),
                    topRight: const Radius.circular(18),
                    bottomLeft: Radius.circular(isMe ? 18 : 4),
                    bottomRight: Radius.circular(isMe ? 4 : 18),
                  ),
                  boxShadow: context.softShadow,
                ),
                child: message.isLoading
                    ? _TypingDots(isMe: isMe)
                    : Text(
                        message.text,
                        style: TextStyle(
                          fontSize: 15,
                          height: 1.4,
                          color: isMe ? Colors.white : c.textPrimary,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Typing dots
// ─────────────────────────────────────────────────────────────

class _TypingDots extends StatefulWidget {
  const _TypingDots({required this.isMe});
  final bool isMe;

  @override
  State<_TypingDots> createState() => _TypingDotsState();
}

class _TypingDotsState extends State<_TypingDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.isMe ? Colors.white70 : context.colors.textSecondary;
    return SizedBox(
      height: 18,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(3, (i) {
          return AnimatedBuilder(
            animation: _ctrl,
            builder: (context, _) {
              final phase = (_ctrl.value - i * 0.22).clamp(0.0, 1.0);
              final bounce = (sin(phase * pi)).clamp(0.0, 1.0);
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3),
                child: Transform.translate(
                  offset: Offset(0, -4 * bounce),
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: BoxDecoration(color: color, shape: BoxShape.circle),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────
// Input bar — mic idle / recording / sending states
// ─────────────────────────────────────────────────────────────

class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.isRecording,
    required this.isSending,
    required this.duration,
    required this.bars,
    required this.onMicTap,
    required this.onSend,
    required this.onDelete,
  });

  final bool isRecording;
  final bool isSending;
  final Duration duration;
  final List<double> bars;
  final VoidCallback onMicTap;
  final VoidCallback onSend;
  final VoidCallback onDelete;

  String get _recTime {
    final min = duration.inMinutes.remainder(60);
    final sec = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$min:$sec';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Container(
      decoration: BoxDecoration(
        color: c.surface,
        border: Border(top: BorderSide(color: c.border)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (child, anim) =>
            FadeTransition(opacity: anim, child: child),
        child: isRecording
            ? _RecordingRow(
                key: const ValueKey('rec'),
                recTime: _recTime,
                bars: bars,
                onDelete: onDelete,
                onSend: onSend,
              )
            : _MicRow(
                key: const ValueKey('mic'),
                isSending: isSending,
                onTap: onMicTap,
              ),
      ),
    );
  }
}

// ─── Mic idle row ─────────────────────────────────────────────

class _MicRow extends StatelessWidget {
  const _MicRow({super.key, required this.isSending, required this.onTap});
  final bool isSending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: c.surfaceSecondary,
              borderRadius: RadiusTokens.pill,
            ),
            child: Text(
              isSending ? 'Transcribing...' : 'Tap mic to speak',
              style: TextStyle(fontSize: 14, color: c.textSecondary),
            ),
          ),
        ),
        const SizedBox(width: SpacingTokens.md),
        GestureDetector(
          onTap: isSending ? null : onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSending
                  ? c.textTertiary
                  : c.primary,
              shape: BoxShape.circle,
              boxShadow: isSending
                  ? []
                  : [
                      BoxShadow(
                        color: c.primary.withValues(alpha: 0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
            ),
            child: isSending
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: Padding(
                      padding: EdgeInsets.all(14),
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                  )
                : const Icon(Icons.mic_rounded, color: Colors.white, size: 26),
          ),
        ),
      ],
    );
  }
}

// ─── Recording row ────────────────────────────────────────────

class _RecordingRow extends StatelessWidget {
  const _RecordingRow({
    super.key,
    required this.recTime,
    required this.bars,
    required this.onDelete,
    required this.onSend,
  });

  final String recTime;
  final List<double> bars;
  final VoidCallback onDelete;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Row(
      children: [
        // Delete button
        GestureDetector(
          onTap: onDelete,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.danger.withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.delete_outline_rounded, color: c.danger, size: 22),
          ),
        ),
        const SizedBox(width: SpacingTokens.sm),

        // Waveform + timer
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: c.danger.withValues(alpha: 0.06),
              borderRadius: RadiusTokens.pill,
              border: Border.all(color: c.danger.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                // REC dot
                Container(
                  width: 7,
                  height: 7,
                  decoration:
                      BoxDecoration(color: c.danger, shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                // Timer
                Text(
                  recTime,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: c.danger,
                    fontFeatures: const [FontFeature.tabularFigures()],
                  ),
                ),
                const SizedBox(width: 8),
                // Waveform
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: bars
                        .map((h) => AnimatedContainer(
                              duration: const Duration(milliseconds: 80),
                              width: 2.5,
                              height: (h * 28).clamp(3.0, 28.0),
                              decoration: BoxDecoration(
                                color: c.danger.withValues(alpha: 0.5 + h * 0.5),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ))
                        .toList(),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: SpacingTokens.sm),

        // Send button
        GestureDetector(
          onTap: onSend,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: c.primary,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: c.primary.withValues(alpha: 0.35),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
          ),
        ),
      ],
    );
  }
}
