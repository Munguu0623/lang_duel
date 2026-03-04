import 'package:flutter/material.dart';

import '../../app/routes.dart';
import '../../core/theme/tokens.dart';
import '../../features/auth/widgets/auth_bottom_sheet.dart';
import '../../mock/fake_data.dart';
import '../../ui/widgets/empty_state.dart';
import '../../ui/widgets/section_header.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_stats_row.dart';
import 'widgets/recent_match_tile.dart';
import 'widgets/season_progress_card.dart';
import 'widgets/social_energy_strip.dart';
import 'widgets/start_duel_card.dart';

/// Home tab — competitive arena feel.
///
/// Layout order:
/// 1. Compact header (notification + level + avatar)
/// 2. Hero section (competitive headline + CTA with glow)
/// 3. Stat hierarchy (rank dominant, win rate, streak)
/// 4. Social energy strip (live activity indicators)
/// 5. Season progression (tier + countdown)
/// 6. Recent matches (clean list)
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
                level: user.level,
                onNotificationTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Notifications coming soon')),
                  );
                },
              ),
            ),
          ),

          // ─── Hero Section (Arena CTA) ──────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xxl),
              child: StartDuelCard(
                onStartDuel: () async {
                  final authed = await requireAuth(
                    context,
                    reason: AuthReason.duel,
                  );
                  if (!authed || !context.mounted) return;
                  Routes.goToDuelMode(context);
                },
                streak: user.streak,
                rankChange: 5,
              ),
            ),
          ),

          // ─── Stat Hierarchy ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: QuickStatsRow(
                rank: 128,
                winRate: user.winRate,
                streak: user.streak,
              ),
            ),
          ),

          // ─── Social Energy Strip ───────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: const SocialEnergyStrip(),
            ),
          ),

          // ─── Season Progress ───────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: SeasonProgressCard(season: season),
            ),
          ),

          // ─── Recent Matches header ─────────────
          SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Recent matches',
              actionText: 'View more',
              onAction: () {},
            ),
          ),

          // ─── Match list or empty state ─────────
          if (matches.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: EmptyState(
                icon: Icons.sports_esports_rounded,
                title: 'No matches yet',
                subtitle: 'Start your first duel and see results here.',
                actionLabel: 'Start first duel',
                onAction: () async {
                  final authed = await requireAuth(
                    context,
                    reason: AuthReason.duel,
                  );
                  if (!authed || !context.mounted) return;
                  Routes.goToDuelMode(context);
                },
              ),
            )
          else
            SliverList.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.only(bottom: SpacingTokens.md),
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
            child: SizedBox(height: SpacingTokens.xxl),
          ),
        ],
      ),
    );
  }
}
