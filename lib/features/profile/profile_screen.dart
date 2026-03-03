import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../mock/fake_data.dart';
import '../../ui/widgets/section_header.dart';
import '../../ui/widgets/soft_card.dart';
import 'widgets/badge_row.dart';
import 'widgets/match_history_tile.dart';
import 'widgets/profile_header.dart';
import 'widgets/stats_grid.dart';

/// Profile tab — avatar, rank badges, stats grid, badges, match history.
///
/// Performance: CustomScrollView + SliverList.builder for match history,
/// split into dedicated widgets.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final profile = FakeData.profileData;
    final matches = FakeData.recentMatches;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
      child: CustomScrollView(
        slivers: [
          // ─── Profile header ────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: ProfileHeader(user: profile.user),
            ),
          ),

          // ─── Stats grid ────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: StatsGrid(profile: profile),
            ),
          ),

          // ─── Badges ────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Badges',
                      style: Theme.of(context).textTheme.titleLarge),
                  const SizedBox(height: SpacingTokens.md),
                  BadgeRow(badges: profile.badges),
                ],
              ),
            ),
          ),

          // ─── Match History header ──────────
          const SliverToBoxAdapter(
            child: SectionHeader(
              title: 'Match history',
              actionText: 'View all',
            ),
          ),

          // ─── Match list ────────────────────
          SliverList.builder(
            itemCount: matches.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: SpacingTokens.sm),
                child: MatchHistoryTile(match: matches[index]),
              );
            },
          ),

          // ─── Settings actions ──────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.lg),
              child: Column(
                children: [
                  SoftCard(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.edit_rounded, size: 20,
                            color: c.textPrimary),
                        const SizedBox(width: SpacingTokens.md),
                        Text('Edit Profile',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: c.textTertiary),
                      ],
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.sm),
                  SoftCard(
                    onTap: () {},
                    child: Row(
                      children: [
                        Icon(Icons.settings_rounded, size: 20,
                            color: c.textPrimary),
                        const SizedBox(width: SpacingTokens.md),
                        Text('Settings',
                            style: Theme.of(context).textTheme.titleMedium),
                        const Spacer(),
                        Icon(Icons.arrow_forward_ios_rounded,
                            size: 14, color: c.textTertiary),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: SpacingTokens.xxl),
          ),
        ],
      ),
    );
  }
}
