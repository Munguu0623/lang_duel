import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/stat_pill.dart';

/// Horizontal row of 4 stat pills: Rank, Win rate, Streak, Level.
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({
    super.key,
    required this.rank,
    required this.winRate,
    required this.streak,
    required this.level,
  });

  final int rank;
  final double winRate;
  final int streak;
  final String level;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: [
          StatPill(
            icon: Icons.tag_rounded,
            label: '#$rank',
            variant: StatPillVariant.primarySoft,
          ),
          const SizedBox(width: SpacingTokens.sm),
          StatPill(
            icon: Icons.percent_rounded,
            label: '${(winRate * 100).round()}%',
          ),
          const SizedBox(width: SpacingTokens.sm),
          StatPill(
            icon: Icons.local_fire_department_rounded,
            label: '$streak',
            variant: streak > 0
                ? StatPillVariant.successSoft
                : StatPillVariant.neutral,
          ),
          const SizedBox(width: SpacingTokens.sm),
          StatPill(
            icon: Icons.school_rounded,
            label: level,
          ),
        ],
      ),
    );
  }
}
