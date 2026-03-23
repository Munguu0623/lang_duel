import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/constants/app_constants.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🏆 Result Screen — score, breakdown, premium upsell
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userScore = ref.watch(duelUserScoreProvider);
    final botScore = ref.watch(duelBotScoreProvider);
    final user = ref.watch(currentUserProvider);
    final won = userScore > botScore;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              (won ? AppColors.accent : AppColors.danger).withOpacity(0.2),
              AppColors.lightBg,
            ],
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            children: [
              const SizedBox(height: AppSpacing.lg),

              // ── Victory / Defeat Header ──
              _ResultHeader(won: won),

              const SizedBox(height: AppSpacing.xl),

              // ── Score Comparison ──
              _ScoreCard(userScore: userScore, botScore: botScore, won: won),

              const SizedBox(height: AppSpacing.lg),

              // ── Detailed Breakdown (Premium gate) ──
              _BreakdownSection(
                userScore: userScore,
                isPremium: user?.isPremium ?? false,
                onUpgrade: () => context.push(AppRoutes.payment),
              ),

              const SizedBox(height: AppSpacing.xl),

              // ── Action Buttons ──
              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: '⚔️ Дахиад',
                      onTap: () => context.pushReplacement(AppRoutes.matchmaking),
                      color: AppColors.accentOrange,
                      fullWidth: true,
                      size: AppButtonSize.lg,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: AppButton(
                      label: '🏠 Нүүр',
                      onTap: () => context.go(AppRoutes.home),
                      color: AppColors.darkSoft,
                      fullWidth: true,
                      size: AppButtonSize.lg,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Result Header ────────────────────────────────────
class _ResultHeader extends StatelessWidget {
  const _ResultHeader({required this.won});
  final bool won;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          won ? '🏆' : '😤',
          style: const TextStyle(fontSize: 56),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          won ? 'VICTORY!' : 'DEFEAT!',
          style: AppText.displayLg.copyWith(
            color: won ? AppColors.secondary : AppColors.accentOrange,
            fontSize: 28,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          won ? 'Маш сайн ярилаа! 🎉' : 'Дахиад оролдоорой! 💪',
          style: AppText.bodyMd.copyWith(color: AppColors.darkSoft),
        ),
      ],
    );
  }
}

// ── Score Card ───────────────────────────────────────
class _ScoreCard extends StatelessWidget {
  const _ScoreCard({
    required this.userScore,
    required this.botScore,
    required this.won,
  });

  final int userScore;
  final int botScore;
  final bool won;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _PlayerScore(emoji: '😎', name: 'You', score: userScore, color: AppColors.primary),
              Text('VS', style: AppText.displaySm.copyWith(color: AppColors.darkSoft)),
              _PlayerScore(emoji: '🤖', name: 'Bot', score: botScore, color: AppColors.secondary),
            ],
          ),

          const SizedBox(height: AppSpacing.base),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.md),

          // Rewards
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CoinIcon(size: 18),
              const SizedBox(width: 4),
              Text(
                '+${won ? GameConfig.coinsPerWin : GameConfig.coinsPerLoss}',
                style: AppText.headingSm,
              ),
              const SizedBox(width: AppSpacing.lg),
              const Text('⭐', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              Text(
                '+${won ? GameConfig.xpPerWin : GameConfig.xpPerLoss} XP',
                style: AppText.headingSm,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PlayerScore extends StatelessWidget {
  const _PlayerScore({
    required this.emoji,
    required this.name,
    required this.score,
    required this.color,
  });

  final String emoji;
  final String name;
  final int score;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppAvatar(size: 44, emoji: emoji, color: color),
        const SizedBox(height: AppSpacing.sm),
        Text(
          '$score',
          style: AppText.displayMd.copyWith(color: color),
        ),
        Text(name, style: AppText.bodySm),
      ],
    );
  }
}

// ── Breakdown Section ────────────────────────────────
class _BreakdownSection extends StatelessWidget {
  const _BreakdownSection({
    required this.userScore,
    required this.isPremium,
    required this.onUpgrade,
  });

  final int userScore;
  final bool isPremium;
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text('📊 Дэлгэрэнгүй оноо', style: AppText.headingMd),
            if (!isPremium) ...[
              const SizedBox(width: 8),
              const Icon(Icons.lock_rounded, size: 16, color: AppColors.darkSoft),
            ],
          ],
        ),
        const SizedBox(height: AppSpacing.md),

        if (isPremium)
          _PremiumBreakdown(userScore: userScore)
        else
          _LockedBreakdown(onUpgrade: onUpgrade),
      ],
    );
  }
}

class _PremiumBreakdown extends StatelessWidget {
  const _PremiumBreakdown({required this.userScore});
  final int userScore;

  @override
  Widget build(BuildContext context) {
    final categories = [
      ('Grammar', (userScore * 0.35).round(), 30, AppColors.primary),
      ('Vocabulary', (userScore * 0.3).round(), 30, AppColors.info),
      ('Fluency', (userScore * 0.2).round(), 20, AppColors.secondary),
      ('Relevance', (userScore * 0.15).round(), 20, AppColors.accent),
    ];

    return AppCard(
      child: Column(
        children: [
          ...categories.map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 14),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(c.$1, style: AppText.bodySm.copyWith(fontWeight: FontWeight.w700, color: AppColors.dark)),
                        Text('${c.$2}/${c.$3}', style: AppText.headingSm.copyWith(color: c.$4, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 4),
                    AppProgressBar(value: c.$2.toDouble(), max: c.$3.toDouble(), color: c.$4, height: 8),
                  ],
                ),
              )),

          // AI Advice
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
              border: Border(
                left: BorderSide(color: AppColors.secondary, width: 4),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '💡 AI Зөвлөгөө',
                  style: AppText.headingSm.copyWith(color: AppColors.secondary, fontSize: 12),
                ),
                const SizedBox(height: 4),
                Text(
                  '"I really enjoy" → Илүү advanced: "I\'m passionate about" эсвэл "I\'m really into" гэж хэлэхийг оролдоорой.',
                  style: AppText.bodyMd.copyWith(height: 1.6),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LockedBreakdown extends StatelessWidget {
  const _LockedBreakdown({required this.onUpgrade});
  final VoidCallback onUpgrade;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onUpgrade,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.04),
          border: Border.all(color: AppColors.primary.withOpacity(0.2), width: 2),
          borderRadius: BorderRadius.circular(AppRadius.base),
        ),
        child: Column(
          children: [
            const Text('🔒', style: TextStyle(fontSize: 32)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'Premium-д нэгдээд бүх анализаа хар!',
              style: AppText.headingSm.copyWith(color: AppColors.primary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              'Grammar алдаа, AI зөвлөгөө, progress tracking',
              style: AppText.bodySm,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Premium болох →',
              onTap: onUpgrade,
              color: AppColors.primary,
              size: AppButtonSize.sm,
            ),
          ],
        ),
      ),
    );
  }
}
