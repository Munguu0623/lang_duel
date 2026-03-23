import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:voice_duel/core/theme/app_theme.dart';
import 'package:voice_duel/core/models/models.dart';
import 'package:voice_duel/core/providers/app_providers.dart';
import 'package:voice_duel/core/widgets/shared_widgets.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🏆 Leaderboard Screen — top 3 podium + ranked list
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

class LeaderboardScreen extends ConsumerWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final players = ref.watch(leaderboardProvider);
    final top3 = players.take(3).toList();
    final rest = players.skip(3).toList();

    return Scaffold(
      body: Column(
        children: [
          // ── Header ──
          Container(
            decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 12,
              bottom: 16,
            ),
            width: double.infinity,
            child: Text(
              '🏆 Leaderboard',
              style: AppText.displayMd.copyWith(color: AppColors.white),
              textAlign: TextAlign.center,
            ),
          ),

          // ── Top 3 Podium ──
          _Podium(top3: top3),

          // ── Rest of the list ──
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              itemCount: rest.length,
              itemBuilder: (_, i) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: _RankTile(entry: rest[i]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Podium (top 3) ───────────────────────────────────
class _Podium extends StatelessWidget {
  const _Podium({required this.top3});
  final List<LeaderboardEntry> top3;

  static const _rankColors = {
    1: AppColors.gold,
    2: AppColors.silver,
    3: AppColors.bronze,
  };

  @override
  Widget build(BuildContext context) {
    if (top3.length < 3) return const SizedBox.shrink();

    // Display order: 2nd, 1st, 3rd
    final ordered = [top3[1], top3[0], top3[2]];
    final heights = [90.0, 110.0, 75.0];
    final sizes = [48.0, 56.0, 44.0];

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.lg,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(3, (i) {
          final entry = ordered[i];
          final color = _rankColors[entry.rank] ?? AppColors.darkSoft;

          return Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppAvatar(
                  size: sizes[i],
                  emoji: entry.emoji,
                  color: color,
                ),
                const SizedBox(height: 6),
                Text(
                  entry.displayName,
                  style: AppText.headingSm.copyWith(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Text(
                  '${entry.score}',
                  style: AppText.bodySm.copyWith(
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  height: heights[i],
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [color, color.withOpacity(0.6)],
                    ),
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(12),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '#${entry.rank}',
                    style: AppText.displaySm.copyWith(
                      color: AppColors.white,
                      fontSize: 22,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

// ── Rank Tile (4th and below) ────────────────────────
class _RankTile extends StatelessWidget {
  const _RankTile({required this.entry});
  final LeaderboardEntry entry;

  Color get _tierColor => switch (entry.tier) {
    TierLevel.gold    => AppColors.gold,
    TierLevel.silver  => AppColors.silver,
    TierLevel.bronze  => AppColors.bronze,
    TierLevel.diamond => AppColors.info,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: entry.isCurrentUser
            ? AppColors.primary.withOpacity(0.08)
            : AppColors.white,
        border: entry.isCurrentUser
            ? Border.all(color: AppColors.primary, width: 2)
            : null,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 28,
            child: Text(
              '${entry.rank}',
              style: AppText.displaySm.copyWith(
                color: AppColors.darkSoft,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),

          // Avatar
          AppAvatar(
            size: 34,
            emoji: entry.emoji,
            color: entry.isCurrentUser ? AppColors.primary : AppColors.darkSoft,
            borderWidth: 2,
          ),
          const SizedBox(width: AppSpacing.md),

          // Name + tier
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      entry.displayName,
                      style: AppText.headingSm.copyWith(fontSize: 13),
                    ),
                    if (entry.isCurrentUser)
                      Text(
                        ' (Би)',
                        style: AppText.bodySm.copyWith(
                          color: AppColors.primary,
                          fontSize: 10,
                        ),
                      ),
                  ],
                ),
                AppBadge(
                  text: entry.tier.label,
                  color: _tierColor.withOpacity(0.15),
                  textColor: _tierColor,
                ),
              ],
            ),
          ),

          // Score
          Text(
            '${entry.score}',
            style: AppText.displaySm.copyWith(
              color: AppColors.primary,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
