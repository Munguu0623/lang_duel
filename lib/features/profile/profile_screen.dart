import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 👤 Profile Screen — stats, achievements, settings
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──
          _ProfileHeader(user: user),

          // ── Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // Premium CTA
                if (!user.isPremium) ...[
                  _PremiumCta(onTap: () => context.push(AppRoutes.payment)),
                  const SizedBox(height: AppSpacing.lg),
                ],

                // Stats
                Text('📊 Статистик', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                _StatsGrid(user: user),

                const SizedBox(height: AppSpacing.xl),

                // Achievements
                Text('🏅 Амжилтууд', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                ..._achievements.map((a) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: _AchievementTile(achievement: a),
                    )),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Achievements Data ────────────────────────────────
const _achievements = [
  _Achievement(emoji: '🎤', title: 'First Voice', desc: 'Анхны duel тоглосон', done: true),
  _Achievement(emoji: '🔥', title: 'On Fire', desc: '3 дараалсан ялалт', done: true),
  _Achievement(emoji: '⚡', title: 'Speed Talker', desc: '20 сек дотор хариулсан', done: true),
  _Achievement(emoji: '👑', title: 'Champion', desc: '50 ялалт', done: false),
  _Achievement(emoji: '🌟', title: 'Polyglot', desc: 'C1 түвшинд хүрсэн', done: false),
];

class _Achievement {
  const _Achievement({
    required this.emoji,
    required this.title,
    required this.desc,
    required this.done,
  });
  final String emoji;
  final String title;
  final String desc;
  final bool done;
}

// ── Profile Header ───────────────────────────────────
class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        bottom: 24,
      ),
      child: Column(
        children: [
          // Avatar
          Stack(
            clipBehavior: Clip.none,
            children: [
              AppAvatar(size: 72, emoji: user.emoji, color: AppColors.accent),
              if (user.isPremium)
                const Positioned(
                  top: -6,
                  right: -6,
                  child: Text('👑', style: TextStyle(fontSize: 22)),
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            user.displayName,
            style: AppText.displayMd.copyWith(color: AppColors.white),
          ),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AppBadge(
                text: user.tier.label,
                color: Colors.white.withOpacity(0.15),
                textColor: AppColors.white,
              ),
              const SizedBox(width: 8),
              AppBadge(
                text: 'Level ${user.level}',
                color: Colors.white.withOpacity(0.15),
                textColor: AppColors.white,
              ),
              if (user.isPremium) ...[
                const SizedBox(width: 8),
                const AppBadge(
                  text: '👑 PREMIUM',
                  color: AppColors.accent,
                  textColor: AppColors.dark,
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.md),

          // Level progress
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Level ${user.level}',
                      style: AppText.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      'Level ${user.level + 1}',
                      style: AppText.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const AppProgressBar(value: 65, color: AppColors.accent, height: 8),
                const SizedBox(height: 4),
                Text(
                  '350 XP дутуу',
                  style: AppText.bodySm.copyWith(color: Colors.white60),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Premium CTA ──────────────────────────────────────
class _PremiumCta extends StatelessWidget {
  const _PremiumCta({required this.onTap});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      color: AppColors.accent.withOpacity(0.12),
      border: Border.all(color: AppColors.accent.withOpacity(0.3), width: 2),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          const Text('👑', style: TextStyle(fontSize: 28)),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Premium болох', style: AppText.headingSm),
                Text('AI анализ + хязгааргүй duel', style: AppText.bodySm),
              ],
            ),
          ),
          Text('→', style: AppText.headingSm.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }
}

// ── Stats Grid ───────────────────────────────────────
class _StatsGrid extends StatelessWidget {
  const _StatsGrid({required this.user});
  final dynamic user;

  @override
  Widget build(BuildContext context) {
    final stats = [
      ('⚔️', 'Нийт Duel', '${user.totalDuels}'),
      ('🏆', 'Ялалт', '${user.wins}'),
      ('📈', 'Win Rate', '${user.winRate.toStringAsFixed(0)}%'),
      ('🔥', 'Streak', '${user.streak} өдөр'),
      ('⭐', 'XP', '${user.xp}'),
      ('🪙', 'Coins', '${user.coins}'),
    ];

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: stats.map((s) {
        return SizedBox(
          width: (MediaQuery.of(context).size.width - 56) / 3,
          child: AppCard(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Column(
              children: [
                Text(s.$1, style: const TextStyle(fontSize: 20)),
                const SizedBox(height: 4),
                Text(s.$3, style: AppText.displaySm),
                const SizedBox(height: 2),
                Text(s.$2, style: AppText.label.copyWith(fontSize: 9)),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

// ── Achievement Tile ─────────────────────────────────
class _AchievementTile extends StatelessWidget {
  const _AchievementTile({required this.achievement});
  final _Achievement achievement;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: achievement.done ? 1 : 0.5,
      child: AppCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: achievement.done
                    ? AppColors.accent.withOpacity(0.15)
                    : AppColors.light,
                borderRadius: BorderRadius.circular(12),
              ),
              alignment: Alignment.center,
              child: Text(achievement.emoji, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(achievement.title, style: AppText.headingSm.copyWith(fontSize: 13)),
                  Text(achievement.desc, style: AppText.bodySm),
                ],
              ),
            ),
            Icon(
              achievement.done ? Icons.check_circle_rounded : Icons.lock_rounded,
              color: achievement.done ? AppColors.success : AppColors.darkSoft,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
