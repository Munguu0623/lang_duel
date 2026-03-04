import 'dart:math';

import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/pressable_scale.dart';
import '../../../ui/widgets/soft_card.dart';

/// Shows the paywall bottom sheet. Returns `true` if the user purchased,
/// or `null` if dismissed.
Future<bool?> showPaywallBottomSheet(BuildContext context) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const _PaywallBottomSheet(),
  );
}

enum _SheetStep { paywall, confirmation }

class _PaywallBottomSheet extends StatefulWidget {
  const _PaywallBottomSheet();

  @override
  State<_PaywallBottomSheet> createState() => _PaywallBottomSheetState();
}

class _PaywallBottomSheetState extends State<_PaywallBottomSheet>
    with TickerProviderStateMixin {
  _SheetStep _step = _SheetStep.paywall;
  int _selectedPlan = 1; // 0 = monthly, 1 = yearly

  // Paywall animations
  late final AnimationController _heroAnim;
  late final AnimationController _featuresAnim;
  late final AnimationController _plansAnim;
  late final AnimationController _ctaAnim;

  // Confirmation animations
  AnimationController? _checkAnim;
  AnimationController? _ringAnim;
  AnimationController? _contentAnim;
  AnimationController? _particleAnim;

  @override
  void initState() {
    super.initState();
    _heroAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _featuresAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _plansAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _ctaAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    Future.microtask(() async {
      _heroAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _featuresAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _plansAnim.forward();
      await Future.delayed(const Duration(milliseconds: 200));
      if (!mounted) return;
      _ctaAnim.forward();
    });
  }

  @override
  void dispose() {
    _heroAnim.dispose();
    _featuresAnim.dispose();
    _plansAnim.dispose();
    _ctaAnim.dispose();
    _checkAnim?.dispose();
    _ringAnim?.dispose();
    _contentAnim?.dispose();
    _particleAnim?.dispose();
    super.dispose();
  }

  void _onStartTrial() {
    // Create confirmation animations
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

    setState(() => _step = _SheetStep.confirmation);

    Future.microtask(() async {
      _ringAnim!.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      if (!mounted) return;
      _checkAnim!.forward();
      _particleAnim!.forward();
      await Future.delayed(const Duration(milliseconds: 400));
      if (!mounted) return;
      _contentAnim!.forward();

      // Auto-close after 2 seconds
      await Future.delayed(const Duration(seconds: 2));
      if (!mounted) return;
      Navigator.of(context).pop(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: c.background,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(20),
            ),
          ),
          child: AnimatedSwitcher(
            duration: DurationTokens.medium,
            child: _step == _SheetStep.paywall
                ? _buildPaywall(c, scrollController)
                : _buildConfirmation(c),
          ),
        );
      },
    );
  }

  // ─── Paywall Step ───────────────────────────────────────────

  Widget _buildPaywall(AppColors c, ScrollController scrollController) {
    return Column(
      key: const ValueKey('paywall'),
      children: [
        // Handle bar + close button
        Padding(
          padding: const EdgeInsets.only(
            top: SpacingTokens.sm,
            left: SpacingTokens.base,
            right: SpacingTokens.base,
          ),
          child: Row(
            children: [
              const SizedBox(width: 40),
              Expanded(
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: c.border,
                      borderRadius: RadiusTokens.pill,
                    ),
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.surfaceSecondary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.close_rounded,
                    color: c.textSecondary,
                    size: 22,
                  ),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            controller: scrollController,
            padding:
                const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
            child: Column(
              children: [
                const SizedBox(height: SpacingTokens.lg),
                _fadeSlide(_heroAnim, child: _buildHero(c)),
                const SizedBox(height: SpacingTokens.xl),
                _fadeSlide(_featuresAnim, child: _buildFeatures(c)),
                const SizedBox(height: SpacingTokens.xxl),
                _fadeSlide(_plansAnim, child: _buildPlans(c)),
                const SizedBox(height: SpacingTokens.xxl),
                _fadeSlide(_ctaAnim, child: _buildCTA(c)),
                const SizedBox(height: SpacingTokens.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _fadeSlide(AnimationController controller, {required Widget child}) {
    final curved =
        CurvedAnimation(parent: controller, curve: Curves.easeOut);
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }

  Widget _buildHero(AppColors c) {
    return Column(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: c.primaryLight,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.diamond_rounded,
            color: c.primary,
            size: 36,
          ),
        ),
        const SizedBox(height: SpacingTokens.lg),
        Text(
          'Upgrade to\nLangDuel Pro',
          textAlign: TextAlign.center,
          style: TextStyles.headlineLarge.copyWith(
            color: c.textPrimary,
            height: 1.1,
          ),
        ),
        const SizedBox(height: SpacingTokens.sm),
        Text(
          'Train like a champion.',
          style: TextStyles.bodyLarge.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }

  Widget _buildFeatures(AppColors c) {
    const features = [
      (Icons.psychology_rounded, 'Advanced AI Analysis',
          'Deep insights into your speech patterns'),
      (Icons.record_voice_over_rounded, 'Pronunciation Coaching',
          'Word-by-word feedback from AI'),
      (Icons.replay_rounded, 'Duel Replay',
          'Review and learn from past matches'),
      (Icons.shield_rounded, 'Rank Protection',
          'Shield your rank from losing streaks'),
      (Icons.lightbulb_rounded, 'Weak Word Detection',
          'Identify and improve problem areas'),
      (Icons.insights_rounded, 'Progress Analytics',
          'Track your improvement over time'),
    ];

    return Column(
      children: [
        for (int i = 0; i < features.length; i++) ...[
          if (i > 0) const SizedBox(height: SpacingTokens.md),
          SoftCard(
            leadingIcon: features[i].$1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  features[i].$2,
                  style:
                      TextStyles.labelLarge.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  features[i].$3,
                  style:
                      TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPlans(AppColors c) {
    return Column(
      children: [
        _PlanCard(
          isSelected: _selectedPlan == 0,
          title: 'Monthly',
          price: '\$6.99',
          period: '/ month',
          onTap: () => setState(() => _selectedPlan = 0),
        ),
        const SizedBox(height: SpacingTokens.md),
        _PlanCard(
          isSelected: _selectedPlan == 1,
          title: 'Yearly',
          price: '\$49',
          period: '/ year',
          badge: 'Save 40%',
          onTap: () => setState(() => _selectedPlan = 1),
        ),
      ],
    );
  }

  Widget _buildCTA(AppColors c) {
    return Column(
      children: [
        PrimaryButton(
          label: 'Start Free Trial',
          size: ButtonSize.lg,
          onPressed: _onStartTrial,
        ),
        const SizedBox(height: SpacingTokens.base),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today_rounded, size: 14, color: c.primary),
            const SizedBox(width: 6),
            Text(
              '7 day free trial',
              style: TextStyles.caption.copyWith(color: c.textSecondary),
            ),
            const SizedBox(width: SpacingTokens.base),
            Icon(Icons.cancel_rounded, size: 14, color: c.primary),
            const SizedBox(width: 6),
            Text(
              'Cancel anytime',
              style: TextStyles.caption.copyWith(color: c.textSecondary),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.lg),
        Text(
          'Payment handled securely by\nApple App Store or Google Play.',
          textAlign: TextAlign.center,
          style: TextStyles.caption.copyWith(
            color: c.textTertiary,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  // ─── Confirmation Step ──────────────────────────────────────

  Widget _buildConfirmation(AppColors c) {
    return Center(
      key: const ValueKey('confirmation'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 2),

            // Animated checkmark
            SizedBox(
              width: 160,
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Particle burst
                  if (_particleAnim != null)
                    AnimatedBuilder(
                      animation: _particleAnim!,
                      builder: (context, child) {
                        return CustomPaint(
                          size: const Size(160, 160),
                          painter: _ParticlePainter(
                            progress: _particleAnim!.value,
                            color: c.primary,
                          ),
                        );
                      },
                    ),

                  // Outer glow ring
                  if (_ringAnim != null)
                    AnimatedBuilder(
                      animation: _ringAnim!,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: 0.5 +
                              (0.5 *
                                  Curves.elasticOut
                                      .transform(_ringAnim!.value)),
                          child: Opacity(
                            opacity: _ringAnim!.value.clamp(0.0, 1.0),
                            child: Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: c.primaryLight,
                                border: Border.all(
                                  color:
                                      c.primary.withValues(alpha: 0.3),
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
                  if (_checkAnim != null)
                    AnimatedBuilder(
                      animation: _checkAnim!,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: Curves.elasticOut.transform(
                            _checkAnim!.value.clamp(0.0, 1.0),
                          ),
                          child: Container(
                            width: 88,
                            height: 88,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: c.primary,
                              boxShadow:
                                  ElevationTokens.primaryGlow(0.4),
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

            // Content
            if (_contentAnim != null)
              FadeTransition(
                opacity: CurvedAnimation(
                  parent: _contentAnim!,
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: _contentAnim!,
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
                    ],
                  ),
                ),
              ),

            const Spacer(flex: 3),
          ],
        ),
      ),
    );
  }
}

// ─── Plan Card ────────────────────────────────────────────────

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.isSelected,
    required this.title,
    required this.price,
    required this.period,
    required this.onTap,
    this.badge,
  });

  final bool isSelected;
  final String title;
  final String price;
  final String period;
  final String? badge;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return PressableScale(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(SpacingTokens.lg),
        decoration: BoxDecoration(
          color: c.surface,
          borderRadius: RadiusTokens.card,
          border: Border.all(
            color: isSelected ? c.primary : c.border,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? ElevationTokens.primaryGlow(0.15)
              : context.softShadow,
        ),
        child: Row(
          children: [
            // Radio indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? c.primary : c.textTertiary,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: c.primary,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: SpacingTokens.base),

            // Plan info
            Expanded(
              child: Row(
                children: [
                  Text(
                    title,
                    style: TextStyles.titleMedium.copyWith(
                      color: isSelected ? c.textPrimary : c.textSecondary,
                    ),
                  ),
                  if (badge != null) ...[
                    const SizedBox(width: SpacingTokens.sm),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: RadiusTokens.pill,
                        color: c.primary,
                      ),
                      child: Text(
                        badge!,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Price
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              textBaseline: TextBaseline.alphabetic,
              children: [
                Text(
                  price,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    color: isSelected ? c.textPrimary : c.textSecondary,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  period,
                  style:
                      TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Particle Painter ─────────────────────────────────────────

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
