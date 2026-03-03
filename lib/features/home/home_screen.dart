import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/tokens.dart';
import '../../mock/fake_data.dart';
import '../../ui/widgets/empty_state.dart';
import '../../ui/widgets/section_header.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_stats_row.dart';
import 'widgets/recent_match_tile.dart';
import 'widgets/season_progress_card.dart';
import 'widgets/start_duel_card.dart';

/// Home tab — greeting, stats, Start Duel CTA, season, recent matches.
///
/// Performance: SliverList.builder for match list, const where possible,
/// widgets split into separate files to avoid monolithic build method.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FakeData.currentUser;
    final matches = FakeData.recentMatches;
    final season = FakeData.season;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
      child: CustomScrollView(
        slivers: [
          // ─── Header ──────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.base),
              child: HomeHeader(
                username: user.name,
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Notifications coming soon')),
                  );
                },
              ),
            ),
          ),

          // ─── Quick Stats ─────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: QuickStatsRow(
                rank: 128,
                winRate: user.winRate,
                streak: user.streak,
                level: user.level,
              ),
            ),
          ),

          // ─── Start Duel CTA ──────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xxl),
              child: StartDuelCard(
                onStartDuel: () => Routes.goToDuelMode(context),
              ),
            ),
          ),

          // ─── Season Progress ─────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: SeasonProgressCard(season: season),
            ),
          ),

          // ─── Recent Matches header ───────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recent matches',
              actionText: 'View more',
              onAction: () {},
            ),
          ),

          // ─── Match list or empty state ───────────
          if (matches.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.sports_esports_rounded,
                title: 'No matches yet',
                subtitle: 'Start your first duel and see results here.',
                actionLabel: 'Start first duel',
                onAction: () => Routes.goToDuelMode(context),
              ),
            )
          else
            SliverList.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: SpacingTokens.md),
                  child: RecentMatchTile(
                    match: matches[index],
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Match vs ${matches[index].opponent.name}',
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: SpacingTokens.base),
          ),
        ],
      ),
    );
  }
}
