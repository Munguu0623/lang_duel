import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 💳 Payment Screen — subscription plans, premium CTA
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class PaymentScreen extends ConsumerStatefulWidget {
  const PaymentScreen({super.key});

  @override
  ConsumerState<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends ConsumerState<PaymentScreen> {
  String _selected = 'monthly';

  static const _plans = [
    _Plan(id: 'weekly', label: '7 хоног', price: '₮4,900', perDay: '₮700/өдөр', popular: false, save: null),
    _Plan(id: 'monthly', label: '1 сар', price: '₮14,900', perDay: '₮496/өдөр', popular: true, save: null),
    _Plan(id: 'yearly', label: '1 жил', price: '₮99,000', perDay: '₮271/өдөр', popular: false, save: '45%'),
  ];

  static const _features = [
    ('♾️', 'Хязгааргүй Duel тоглох'),
    ('📊', 'AI дэлгэрэнгүй анализ'),
    ('💡', 'Grammar алдааны тайлбар'),
    ('📈', 'Progress tracking'),
    ('🎯', 'Сэдэв сонгох эрх'),
    ('🏆', 'Exclusive rank badge'),
  ];

  void _subscribe() {
    ref.read(currentUserProvider.notifier).setPremium(true);
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(currentUserProvider);

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 8,
              left: 20,
              right: 20,
              bottom: 24,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    GestureDetector(
                      onTap: () => context.pop(),
                      child: const Icon(Icons.chevron_left_rounded, color: Colors.white, size: 28),
                    ),
                    const SizedBox(width: 12),
                    Text('Premium', style: AppText.headingLg.copyWith(color: AppColors.white)),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                const Text('👑', style: TextStyle(fontSize: 48)),
                const SizedBox(height: 8),
                Text('PREMIUM БОЛОХ', style: AppText.displayMd.copyWith(color: AppColors.white)),
                const SizedBox(height: 4),
                Text(
                  'Англи хэлний ур чадвараа бүрэн хөгжүүл!',
                  style: AppText.bodyMd.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Coin balance
                AppCard(
                  color: AppColors.accent.withOpacity(0.12),
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    children: [
                      const CoinIcon(size: 24),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Миний Coin: ${user?.coins ?? 0}', style: AppText.headingSm),
                            Text(
                              'Coin-оор хөнгөлөлт авах боломжтой',
                              style: AppText.bodySm,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // Plans
                ..._plans.map((plan) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _PlanTile(
                        plan: plan,
                        selected: _selected == plan.id,
                        onTap: () => setState(() => _selected = plan.id),
                      ),
                    )),

                const SizedBox(height: AppSpacing.lg),

                // Features
                Text('Premium-д юу багтах вэ?', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                AppCard(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: _features
                        .map((f) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Text(f.$1, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: AppSpacing.sm),
                                  Expanded(
                                    child: Text(f.$2, style: AppText.bodyMd.copyWith(fontWeight: FontWeight.w700)),
                                  ),
                                  const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 20),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                AppButton(
                  label: '👑 Premium болох — ${_plans.firstWhere((p) => p.id == _selected).price}',
                  onTap: _subscribe,
                  color: AppColors.primary,
                  fullWidth: true,
                  size: AppButtonSize.lg,
                ),

                const SizedBox(height: AppSpacing.sm),

                Text(
                  'Хүссэн үедээ цуцалж болно · Баталгаатай төлбөр',
                  style: AppText.bodySm,
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Plan Model ───────────────────────────────────────
class _Plan {
  const _Plan({
    required this.id,
    required this.label,
    required this.price,
    required this.perDay,
    required this.popular,
    required this.save,
  });

  final String id;
  final String label;
  final String price;
  final String perDay;
  final bool popular;
  final String? save;
}

// ── Plan Tile ────────────────────────────────────────
class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.plan,
    required this.selected,
    required this.onTap,
  });

  final _Plan plan;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary.withOpacity(0.04) : AppColors.white,
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.light,
            width: selected ? 3 : 2,
          ),
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plan.label, style: AppText.headingSm),
                    Text(plan.perDay, style: AppText.bodySm),
                  ],
                ),
                Text(
                  plan.price,
                  style: AppText.displaySm.copyWith(color: AppColors.primary),
                ),
              ],
            ),
            if (plan.popular)
              Positioned(
                top: -22,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.accentOrange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'POPULAR',
                    style: AppText.label.copyWith(color: AppColors.white, fontSize: 10),
                  ),
                ),
              ),
            if (plan.save != null)
              Positioned(
                top: -22,
                right: 12,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: AppColors.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${plan.save} ХЯМД',
                    style: AppText.label.copyWith(color: AppColors.white, fontSize: 10),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
