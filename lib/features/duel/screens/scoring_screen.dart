import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/network/api_client.dart';
import '../../../core/network/api_exception.dart';
import '../../../core/theme/tokens.dart';
import '../../../features/auth/auth_service.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/skeleton.dart';
import '../../../ui/widgets/top_bar.dart';
import '../data/duel_models.dart';
import '../data/duel_repository.dart';

/// "AI is judging..." дэлгэц — GET /duel/result/:matchId-г 2 секунд тутамд poll хийнэ.
///
/// Урсгал:
///   waiting_submit   → submission ирэхгүй хүлээнэ
///   waiting_opponent → өрсөлдөгчийг хүлээнэ
///   done             → [onDone]-г дуудна
///
/// Fallback: [_kMaxPollSec] секундын дотор done ирэхгүй бол FakeData ашиглана.
class ScoringScreen extends StatefulWidget {
  const ScoringScreen({
    super.key,
    required this.matchId,
    required this.currentUserId,
    required this.onDone,
  });

  final String matchId;

  /// Ялагчийг тодорхойлоход ашиглах — [DuelDoneResult.winnerUserId]-тай харьцуулна.
  final String currentUserId;

  final ValueChanged<DuelResult> onDone;

  @override
  State<ScoringScreen> createState() => _ScoringScreenState();
}

class _ScoringScreenState extends State<ScoringScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _dotController;
  Timer? _pollTimer;

  /// Poll дуусгах хамгийн их хугацаа (секунд).
  static const _kMaxPollSec = 60;
  int _elapsedSec = 0;

  late final DuelRepository _repo;

  @override
  void initState() {
    super.initState();
    _dotController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();

    // matchId хоосон байвал (ер бусын тохиолдол) шууд fallback.
    if (widget.matchId.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _stopAndFallback());
      return;
    }

    _repo = DuelRepository(ApiClient(bearerToken: authService.token));

    // Шууд нэг poll хийгээд 2 секунд тутамд үргэлжлүүлнэ.
    _poll();
    _pollTimer = Timer.periodic(const Duration(seconds: 2), (_) {
      _elapsedSec += 2;
      if (_elapsedSec >= _kMaxPollSec) {
        _stopAndFallback();
      } else {
        _poll();
      }
    });
  }

  Future<void> _poll() async {
    if (!mounted) return;
    try {
      final result = await _repo.pollResult(widget.matchId);
      if (!mounted) return;

      switch (result) {
        case DuelDoneResult():
          _pollTimer?.cancel();
          widget.onDone(result.toDuelResult());

        case WaitingSubmitResult():
        case WaitingOpponentResult():
          // Хүлээсэн хэвээр — poll үргэлжилнэ.
          break;
      }
    } on ApiException {
      // Сүлжээний/серверийн алдаа — дараагийн poll хүртэл хүлээнэ.
    } catch (_) {
      // Тодорхойгүй алдаа — дараагийн poll хүртэл хүлээнэ.
    }
  }

  void _stopAndFallback() {
    _pollTimer?.cancel();
    if (!mounted) return;
    widget.onDone(FakeData.generateFakeResult());
  }

  @override
  void dispose() {
    _dotController.dispose();
    _pollTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final dotColors = [c.primary, c.accent, c.accentCyan];

    return SafeArea(
      child: Column(
        children: [
          const TopBar(title: 'Scoring'),
          const Spacer(),
          // Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: c.primary,
              boxShadow: [
                BoxShadow(
                  color: c.primary.withValues(alpha: 0.30),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: SpacingTokens.xl),
          Text(
            'AI is judging...',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: SpacingTokens.md),
          AnimatedBuilder(
            animation: _dotController,
            builder: (context, _) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(3, (i) {
                  final delay = i * 0.2;
                  final value =
                      ((_dotController.value - delay) % 1.0).clamp(0.0, 1.0);
                  final opacity = (value < 0.5)
                      ? (value * 2).clamp(0.2, 1.0)
                      : ((1.0 - value) * 2).clamp(0.2, 1.0);
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Opacity(
                      opacity: opacity,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: dotColors[i],
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: SpacingTokens.sm),
          Text(
            'Analyzing pronunciation, grammar, fluency...',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: SpacingTokens.xl),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: SpacingTokens.base),
            child: SkeletonCard(),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
