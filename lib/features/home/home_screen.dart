import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/router/app_router.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🏠 Home Screen — main hub, start duel, pick topic
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final topics = ref.watch(topicsProvider);
    final dailyCount = ref.watch(dailyDuelCountProvider);
    final canPlay = ref.watch(canPlayDuelProvider);

    if (user == null) return const SizedBox.shrink();

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──
          _Header(user: user, dailyCount: dailyCount),

          // ── Scrollable Content ──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(AppSpacing.lg),
              children: [
                // ── Start Duel Button ──
                _StartDuelCard(
                  canPlay: canPlay,
                  onTap: () => context.push(AppRoutes.matchmaking),
                ),

                const SizedBox(height: AppSpacing.xl),

                // ── Topics ──
                Text('📚 Сэдэв сонгох', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                ...topics.map((topic) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: _TopicCard(
                        emoji: topic.emoji,
                        title: topic.title,
                        level: topic.cefrLevel.label,
                        onTap: () {
                          ref.read(selectedTopicProvider.notifier).state = topic;
                          context.push(AppRoutes.matchmaking);
                        },
                      ),
                    )),

                const SizedBox(height: AppSpacing.xl),

                // ── Quick Stats ──
                Text('📊 Миний статистик', style: AppText.headingMd),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    _StatTile(label: 'Нийт', value: '${user.totalDuels}', color: AppColors.primary),
                    const SizedBox(width: AppSpacing.sm),
                    _StatTile(label: 'Ялалт', value: '${user.wins}', color: AppColors.secondary),
                    const SizedBox(width: AppSpacing.sm),
                    _StatTile(label: 'Win Rate', value: '${user.winRate.toStringAsFixed(0)}%', color: AppColors.accent),
                  ],
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

// ── Header with gradient ─────────────────────────────
class _Header extends StatelessWidget {
  const _Header({required this.user, required this.dailyCount});

  final dynamic user;
  final int dailyCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 12,
        left: 20,
        right: 20,
        bottom: 20,
      ),
      child: Column(
        children: [
          // User row
          Row(
            children: [
              AppAvatar(size: 40, emoji: user.emoji, color: AppColors.accent),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user.displayName,
                      style: AppText.headingSm.copyWith(color: AppColors.white),
                    ),
                    Text(
                      '${user.tier.label} · Level ${user.level}',
                      style: AppText.bodySm.copyWith(color: Colors.white70, fontSize: 11),
                    ),
                  ],
                ),
              ),
              // Streak
              _HeaderChip(icon: '🔥', value: '${user.streak}'),
              const SizedBox(width: AppSpacing.sm),
              // Coins
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Row(
                      children: [
                        const CoinIcon(size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${user.coins}',
                          style: AppText.headingSm.copyWith(
                            color: AppColors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          // Daily progress
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.12),
              borderRadius: BorderRadius.circular(AppRadius.base),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Өнөөдрийн duel: $dailyCount/3',
                      style: AppText.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                    Text(
                      '🆓 Үнэгүй',
                      style: AppText.bodySm.copyWith(color: Colors.white, fontWeight: FontWeight.w700),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                AppProgressBar(
                  value: dailyCount.toDouble(),
                  max: 3,
                  color: AppColors.accent,
                  height: 8,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderChip extends StatelessWidget {
  const _HeaderChip({required this.icon, required this.value});
  final String icon;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 14)),
          const SizedBox(width: 4),
          Text(
            value,
            style: AppText.headingSm.copyWith(color: AppColors.white, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

// ── Start Duel CTA Card ──────────────────────────────
class _StartDuelCard extends StatelessWidget {
  const _StartDuelCard({required this.canPlay, required this.onTap});
  final bool canPlay;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: canPlay ? onTap : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        decoration: BoxDecoration(
          gradient: AppColors.dangerGradient,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          boxShadow: [
            BoxShadow(
              color: AppColors.accentOrange.withOpacity(0.35),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            const Text('⚔️', style: TextStyle(fontSize: 42)),
            const SizedBox(height: AppSpacing.sm),
            Text(
              'START DUEL',
              style: AppText.displayMd.copyWith(color: AppColors.white),
            ),
            const SizedBox(height: 4),
            Text(
              canPlay
                  ? 'Bot-той тэмцээд оноо цуглуул!'
                  : 'Өнөөдрийн лимит дууссан — Premium болох?',
              style: AppText.bodySm.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Topic Card ───────────────────────────────────────
class _TopicCard extends StatelessWidget {
  const _TopicCard({
    required this.emoji,
    required this.title,
    required this.level,
    required this.onTap,
  });

  final String emoji;
  final String title;
  final String level;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.08),
              borderRadius: BorderRadius.circular(14),
            ),
            alignment: Alignment.center,
            child: Text(emoji, style: const TextStyle(fontSize: 22)),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(title, style: AppText.headingSm),
          ),
          AppBadge(
            text: level,
            color: AppColors.primary.withOpacity(0.12),
            textColor: AppColors.primary,
          ),
        ],
      ),
    );
  }
}

// ── Stat Tile ────────────────────────────────────────
class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value, required this.color});
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          children: [
            Text(
              value,
              style: AppText.displaySm.copyWith(color: color),
            ),
            const SizedBox(height: 2),
            Text(label, style: AppText.label),
          ],
        ),
      ),
    );
  }
}
