import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import '../../mock/fake_data.dart';
import '../../mock/fake_models.dart';
import '../../ui/widgets/soft_chip.dart';
import 'widgets/leaderboard_tile.dart';
import 'widgets/top_three_header.dart';

/// Leaderboard tab — Global/Weekly toggle, top-3 podium, ranked list.
///
/// Performance: SliverList.builder for the ranking list, split widgets.
class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  int _selectedTab = 0;
  final _tabs = const ['Global', 'Weekly'];

  @override
  Widget build(BuildContext context) {
    final entries = FakeData.leaderboard;
    final top3 = entries.take(3).toList();
    final rest = entries.skip(3).toList();

    // Find current user's rank for the highlight card.
    final myEntry = entries.firstWhere(
      (e) => e.user.id == FakeData.currentUser.id,
      orElse: () => entries.last,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SpacingTokens.base),
      child: CustomScrollView(
        slivers: [
          // ─── Title with arena letterSpacing ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.base),
              child: Text(
                'Leaderboard',
                style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      letterSpacing: -0.8,
                    ),
              ),
            ),
          ),

          // ─── Toggle chips ──────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.base),
              child: Row(
                children: [
                  for (var i = 0; i < _tabs.length; i++) ...[
                    if (i > 0) const SizedBox(width: SpacingTokens.sm),
                    SoftChip(
                      label: _tabs[i],
                      selected: _selectedTab == i,
                      onTap: () => setState(() => _selectedTab = i),
                    ),
                  ],
                ],
              ),
            ),
          ),

          // ─── Current user rank card with glow ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: SpacingTokens.lg),
              child: _MyRankCard(entry: myEntry),
            ),
          ),

          // ─── Top 3 podium ──────────────────
          if (top3.length == 3)
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.only(top: SpacingTokens.xl),
                child: TopThreeHeader(entries: top3),
              ),
            ),

          // ─── Rankings header ────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(
                top: SpacingTokens.xl,
                bottom: SpacingTokens.sm,
              ),
              child: Text('Rankings',
                  style: Theme.of(context).textTheme.titleLarge),
            ),
          ),

          // ─── Ranked list ───────────────────
          SliverList.builder(
            itemCount: rest.length,
            itemBuilder: (context, index) {
              return LeaderboardTile(entry: rest[index]);
            },
          ),

          const SliverToBoxAdapter(
            child: SizedBox(height: SpacingTokens.base),
          ),
        ],
      ),
    );
  }
}

/// Highlighted card showing the current user's rank at the top.
class _MyRankCard extends StatelessWidget {
  const _MyRankCard({required this.entry});

  final LeaderboardEntry entry;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      children: [
        // Subtle radial glow behind card
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.center,
                radius: 1.2,
                colors: [
                  c.primary.withValues(alpha: 0.06),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.all(SpacingTokens.base),
          decoration: BoxDecoration(
            color: c.primaryLight,
            borderRadius: RadiusTokens.card,
          ),
          child: Row(
            children: [
              // Gradient circle rank badge
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [c.primary, c.accent],
                  ),
                ),
                child: Center(
                  child: Text(
                    '#${entry.rank}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: SpacingTokens.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Your rank',
                        style: Theme.of(context).textTheme.bodyMedium),
                    Text(
                      entry.user.name,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
              Text(
                '${(entry.user.winRate * 100).round()}% WR',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: c.primary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
