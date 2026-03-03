import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Stat hierarchy — Rank visually dominant, win rate + streak energetic.
/// Big number + small label pattern. No B2 level (moved to header).
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({
    super.key,
    required this.rank,
    required this.winRate,
    required this.streak,
  });

  final int rank;
  final double winRate;
  final int streak;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: SpacingTokens.lg,
        horizontal: SpacingTokens.base,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.card,
        boxShadow: context.softShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            // Rank — visually dominant
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '#$rank',
                    style: TextStyles.statLarge.copyWith(
                      fontSize: 32,
                      color: c.textPrimary,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    'Global Rank',
                    style: TextStyles.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.border,
            ),
            // Win Rate
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${(winRate * 100).round()}%',
                    style: TextStyles.statLarge.copyWith(
                      fontSize: 22,
                      color: c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Text(
                    'Win Rate',
                    style: TextStyles.caption.copyWith(color: c.textSecondary),
                  ),
                ],
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.border,
            ),
            // Streak — energetic
            Expanded(
              flex: 2,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '$streak',
                    style: TextStyles.statLarge.copyWith(
                      fontSize: 22,
                      color: streak > 0 ? c.success : c.textPrimary,
                    ),
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (streak > 0) ...[
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 12,
                          color: c.success,
                        ),
                        const SizedBox(width: 2),
                      ],
                      Text(
                        'Streak',
                        style:
                            TextStyles.caption.copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
