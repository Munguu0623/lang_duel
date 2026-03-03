import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../mock/fake_data.dart';
import '../../ui/widgets/section_header.dart';
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
              return MatchHistoryTile(match: matches[index]);
            },
          ),

          // ─── Settings actions — borderless list ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.lg),
              child: Column(
                children: [
                  _SettingsItem(
                    icon: Icons.edit_rounded,
                    label: 'Edit Profile',
                    onTap: () {},
                  ),
                  _SettingsItem(
                    icon: Icons.settings_rounded,
                    label: 'Settings',
                    onTap: () {},
                    showDivider: false,
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

/// Borderless list item with bottom divider + trailing arrow.
class _SettingsItem extends StatelessWidget {
  const _SettingsItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.showDivider = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: SpacingTokens.base,
        ),
        decoration: BoxDecoration(
          border: showDivider
              ? Border(bottom: BorderSide(color: c.border, width: 0.5))
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, size: 20, color: c.textPrimary),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Text(label,
                  style: Theme.of(context).textTheme.titleMedium),
            ),
            Icon(Icons.arrow_forward_ios_rounded,
                size: 14, color: c.textTertiary),
          ],
        ),
      ),
    );
  }
}
