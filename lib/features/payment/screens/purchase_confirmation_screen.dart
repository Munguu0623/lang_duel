import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/primary_button.dart';

/// SCREEN 3 — Purchase Confirmation with animated checkmark.
class PurchaseConfirmationScreen extends StatefulWidget {
  const PurchaseConfirmationScreen({
    super.key,
    required this.onSeeAnalysis,
  });

  final VoidCallback onSeeAnalysis;

  @override
  State<PurchaseConfirmationScreen> createState() =>
      _PurchaseConfirmationScreenState();
}

class _PurchaseConfirmationScreenState extends State<PurchaseConfirmationScreen>
    with TickerProviderStateMixin {
  late final AnimationController _checkAnim;
  late final AnimationController _ringAnim;
  late final AnimationController _contentAnim;
  late final AnimationController _particleAnim;

  @override
  void initState() {
    super.initState();
    _checkAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _ringAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _contentAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _particleAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    Future.microtask(() async {
      _ringAnim.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _checkAnim.forward();
      _particleAnim.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      _contentAnim.forward();
    });
  }

  @override
  void dispose() {
    _checkAnim.dispose();
    _ringAnim.dispose();
    _contentAnim.dispose();
    _particleAnim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Animated checkmark ──
              SizedBox(
                width: 160,
                height: 160,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Particle burst
                    AnimatedBuilder(
                      animation: _particleAnim,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(160, 160),
                          painter: _ParticlePainter(
                            progress: _particleAnim.value,
                            color: c.primary,
                          ),
                        );
                      },
                    ),

                    // Outer glow ring
                    AnimatedBuilder(
                      animation: _ringAnim,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.5 +
                              (0.5 *
                                  Curves.elasticOut
                                      .transform(_ringAnim.value)),
                          child: Opacity(
                            opacity: _ringAnim.value.clamp(0.0, 1.0),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: c.primaryLight,
                                border: Border.all(
                                  color: c.primary.withValues(alpha: 0.3),
                                  width: 2,
                                ),
                                boxShadow:
                                    ElevationTokens.primaryGlow(0.3),
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                    // Inner circle with check icon
                    AnimatedBuilder(
                      animation: _checkAnim,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: Curves.elasticOut.transform(
                            _checkAnim.value.clamp(0.0, 1.0),
                          ),
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c.primary,
                              boxShadow: ElevationTokens.primaryGlow(0.4),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 44,
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: SpacingTokens.xxl),

              // ── Content ──
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _contentAnim,
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _contentAnim,
                    curve: Curves.easeOut,
                  )),
                  child: Column(
                    children: [
                      Text(
                        "You're now a\nPro Duelist.",
                        textAlign: TextAlign.center,
                        style: TextStyles.headlineLarge.copyWith(
                          color: c.textPrimary,
                          height: 1.15,
                        ),
                      ),
                      const SizedBox(height: SpacingTokens.md),
                      Text(
                        'Premium coaching unlocked.',
                        style: TextStyles.bodyLarge
                            .copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(height: SpacingTokens.xxl + 8),

                      PrimaryButton(
                        label: 'See Detailed Analysis',
                        size: ButtonSize.lg,
                        onPressed: widget.onSeeAnalysis,
                      ),
                    ],
                  ),
                ),
              ),

              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}

/// Particle burst effect painter for the confirmation animation.
class _ParticlePainter extends CustomPainter {
  _ParticlePainter({
    required this.progress,
    required this.color,
  });

  final double progress;
  final Color color;
  static final _random = Random(42);

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < 0.1) return;

    final center = Offset(size.width / 2, size.height / 2);
    const particleCount = 12;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);

    for (int i = 0; i < particleCount; i++) {
      final angle =
          (i / particleCount) * 2 * pi + (_random.nextDouble() * 0.5);
      final distance = 30 + progress * (40 + _random.nextDouble() * 30);
      final particleSize =
          (3 + _random.nextDouble() * 3) * (1.0 - progress * 0.5);

      final offset = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );

      canvas.drawCircle(
        offset,
        particleSize,
        Paint()..color = color.withValues(alpha: opacity),
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) =>
      progress != oldDelegate.progress;
}
