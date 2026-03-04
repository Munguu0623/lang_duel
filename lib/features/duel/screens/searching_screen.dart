import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_service.dart';
import '../../../ui/widgets/skeleton.dart';
import '../../../ui/widgets/top_bar.dart';
import '../data/duel_models.dart';
import '../data/duel_repository.dart';

/// Хайлтын дэлгэц — matchmaking дараалалд ороод тохирол хүлээнэ.
///
/// Урсгал:
///   1. Эхлэхэд → [POST /duel/join]-г [cefrLevel]-тай дуудна.
///   2. [WaitingTicket] → [GET /duel/ticket/:id]-г 2 секунд тутамд poll хийнэ.
///   3. [MatchedTicket] → polling зогсоож, match мэдээллийг [onFound]-д дамжуулна.
///   4. [ApiException] гарвал → алдааны мессеж + дахин оролдох товч харуулна.
///   5. Цуцлах → polling зогсоож, [onCancel]-г дуудна.
class SearchingScreen extends StatefulWidget {
  const SearchingScreen({
    super.key,
    required this.cefrLevel,
    required this.onCancel,
    required this.onFound,
  });

  /// Matchmaking-д серверт илгээх CEFR түвшин (жишээ нь `"B1"`).
  final String cefrLevel;

  final VoidCallback onCancel;

  /// [MatchedTicket] ирэхэд (шууд эсвэл polling-ээр) нэг удаа дуудагдана.
  /// Дуудагч тал [DuelUser] + prompt болгон хөрвүүлнэ.
  final ValueChanged<MatchedTicket> onFound;

  @override
  State<SearchingScreen> createState() => _SearchingScreenState();
}

class _SearchingScreenState extends State<SearchingScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;

  /// [GET /duel/ticket/:id]-г 2 секунд тутамд дуудах цагийн хэрэгсэл.
  Timer? _pollTimer;

  /// Эхний [POST /duel/join] хүсэлт явагдаж байх үед true.
  bool _isJoining = true;

  /// [ApiException] урсгалыг зогсоосон бол null биш байна.
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _joinQueue();
  }

  // ── API дуудлагууд ────────────────────────────────────────────────────────

  /// POST /duel/join — matchmaking дараалалд орно.
  Future<void> _joinQueue() async {
    setState(() {
      _isJoining = true;
      _errorMessage = null;
    });

    try {
      final repo = DuelRepository(
        // Дуэлийн бүх endpoint хүчинтэй JWT шаарддаг.
        ApiClient(bearerToken: authService.token),
      );

      final result = await repo.join(cefrLevel: widget.cefrLevel);

      if (!mounted) return;

      switch (result) {
        case MatchedTicket():
          // Азтай — шууд тохирол, polling шаардлагагүй.
          widget.onFound(result);

        case WaitingTicket():
          // Дараалалд орсон — сервер өрсөлдөгч олох эсвэл
          // ~10 секундийн дараа bot тогтоох хүртэл polling хийнэ.
          setState(() => _isJoining = false);
          _startPolling(result.ticketId);
      }
    } on ApiException catch (e) {
      if (mounted) setState(() => _errorMessage = e.message);
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  /// GET /duel/ticket/:ticketId-г 2 секунд тутамд дуудах цагийн хэрэгсэл эхлүүлнэ.
  void _startPolling(String ticketId) {
    _pollTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) => _poll(ticketId),
    );
  }

  /// GET /duel/ticket/:ticketId — өрсөлдөгч олдсон эсэхийг шалгана.
  Future<void> _poll(String ticketId) async {
    try {
      final repo = DuelRepository(ApiClient(bearerToken: authService.token));
      final result = await repo.pollTicket(ticketId);

      if (!mounted) return;

      if (result is MatchedTicket) {
        // Polling зогсоож, flow controller-д шилжүүлнэ.
        _pollTimer?.cancel();
        widget.onFound(result);
      }
      // WaitingTicket → polling үргэлжлүүлнэ; энд хийх зүйлгүй.
    } on ApiException catch (e) {
      _pollTimer?.cancel();
      if (mounted) setState(() => _errorMessage = e.message);
    }
  }

  void _handleCancel() {
    _pollTimer?.cancel();
    widget.onCancel();
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasError = _errorMessage != null;

    return SafeArea(
      child: Column(
        children: [
          TopBar(title: 'Searching', onBack: _handleCancel),
          const Spacer(flex: 2),

          // Pulse animation — тасралтгүй харагдана.
          SizedBox(
            width: 160,
            height: 160,
            child: AnimatedBuilder(
              animation: _pulseController,
              builder: (context, child) {
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    for (var i = 0; i < 3; i++)
                      _PulseCircle(
                        progress: (_pulseController.value + i * 0.33) % 1.0,
                        useAccent: i.isOdd,
                        // Алдаа гарвал pulse-г бүдэгрүүлнэ.
                        dimmed: hasError,
                      ),
                    Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasError ? c.danger : c.primary,
                        boxShadow: [
                          BoxShadow(
                            color: (hasError ? c.danger : c.primary)
                                .withValues(alpha: 0.30),
                            blurRadius: 20,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Icon(
                        hasError
                            ? Icons.error_outline_rounded
                            : Icons.search_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),

          // Төлөв / алдааны текст.
          Text(
            hasError
                ? 'Дараалалд орж чадсангүй'
                : _isJoining
                    ? 'Холбогдож байна...'
                    : 'Зохистой өрсөлдөгч хайж байна...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            hasError
                ? _errorMessage!
                : 'Түвшин: ${widget.cefrLevel} · Хэдэн секунд хүлээнэ үү',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),

          const SizedBox(height: SpacingTokens.xl),

          // Хүлээж байх skeleton — алдааны үед нуугдана.
          if (!hasError)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: SpacingTokens.base),
              child: SkeletonCard(),
            ),

          // Дахин оролдох товч — зөвхөн алдааны үед харагдана.
          if (hasError) ...[
            const SizedBox(height: SpacingTokens.lg),
            FilledButton.icon(
              onPressed: _joinQueue,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Дахин оролдох'),
            ),
          ],

          const Spacer(flex: 3),

          Padding(
            padding: const EdgeInsets.only(bottom: SpacingTokens.xxl),
            child: TextButton(
              onPressed: _handleCancel,
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.xxl,
                  vertical: SpacingTokens.md,
                ),
                shape: const StadiumBorder(),
                backgroundColor: c.surfaceSecondary,
              ),
              child: Text(
                'Цуцлах',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: c.textPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Туслах widget ──────────────────────────────────────────────────────────

class _PulseCircle extends StatelessWidget {
  const _PulseCircle({
    required this.progress,
    this.useAccent = false,
    this.dimmed = false,
  });

  final double progress;
  final bool useAccent;
  final bool dimmed;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final color = useAccent ? c.accent : c.primary;
    return Opacity(
      opacity: dimmed ? 0.2 : (1.0 - progress).clamp(0.0, 0.3),
      child: Container(
        width: 64 + progress * 96,
        height: 64 + progress * 96,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: color, width: 2),
        ),
      ),
    );
  }
}
