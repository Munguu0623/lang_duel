import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/primary_button.dart';
import '../../../ui/widgets/pressable_scale.dart';
import '../../../ui/widgets/soft_card.dart';

/// SCREEN 2 — Premium Paywall.
class PremiumPaywallScreen extends StatefulWidget {
  const PremiumPaywallScreen({
    super.key,
    required this.onStartTrial,
    required this.onClose,
  });

  final VoidCallback onStartTrial;
  final VoidCallback onClose;

  @override
  State<PremiumPaywallScreen> createState() => _PremiumPaywallScreenState();
}

class _PremiumPaywallScreenState extends State<PremiumPaywallScreen>
    with TickerProviderStateMixin {
  int _selectedPlan = 1; // 0 = monthly, 1 = yearly

  late final AnimationController _heroAnim;
  late final AnimationController _featuresAnim;
  late final AnimationController _plansAnim;
  late final AnimationController _ctaAnim;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(SpacingTokens.base),
                child: GestureDetector(
                  onTap: widget.onClose,
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
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
                child: Column(
                  children: [
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
        ),
      ),
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
        // Pro badge icon
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
    final features = [
      _FeatureItem(Icons.psychology_rounded, 'Advanced AI Analysis',
          'Deep insights into your speech patterns'),
      _FeatureItem(Icons.record_voice_over_rounded, 'Pronunciation Coaching',
          'Word-by-word feedback from AI'),
      _FeatureItem(Icons.replay_rounded, 'Duel Replay',
          'Review and learn from past matches'),
      _FeatureItem(Icons.shield_rounded, 'Rank Protection',
          'Shield your rank from losing streaks'),
      _FeatureItem(Icons.lightbulb_rounded, 'Weak Word Detection',
          'Identify and improve problem areas'),
      _FeatureItem(Icons.insights_rounded, 'Progress Analytics',
          'Track your improvement over time'),
    ];

    return Column(
      children: [
        for (int i = 0; i < features.length; i++) ...[
          if (i > 0) const SizedBox(height: SpacingTokens.md),
          SoftCard(
            leadingIcon: features[i].icon,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  features[i].label,
                  style:
                      TextStyles.labelLarge.copyWith(color: c.textPrimary),
                ),
                const SizedBox(height: 2),
                Text(
                  features[i].description,
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
          onPressed: widget.onStartTrial,
        ),
        const SizedBox(height: SpacingTokens.base),

        // Trial info
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
}

/// Subscription plan card.
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
                  style: TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem(this.icon, this.label, this.description);

  final IconData icon;
  final String label;
  final String description;
}
