import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// 2x2 grid: Total Matches, Wins, Win Rate, Current Streak.
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.profile,
  });

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    final winRate = profile.totalMatches > 0
        ? ((profile.wins / profile.totalMatches) * 100).round()
        : 0;

    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Total Matches',
                value: '${profile.totalMatches}',
              ),
            ),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: _StatCell(
                label: 'Wins',
                value: '${profile.wins}',
              ),
            ),
          ],
        ),
        const SizedBox(height: SpacingTokens.md),
        Row(
          children: [
            Expanded(
              child: _StatCell(
                label: 'Win Rate',
                value: '$winRate%',
              ),
            ),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: _StatCell(
                label: 'Current Streak',
                value: '${profile.user.streak}',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      decoration: BoxDecoration(
        color: c.surfaceSecondary,
        borderRadius: RadiusTokens.medium,
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyles.statLarge.copyWith(color: c.textPrimary),
          ),
          const SizedBox(height: SpacingTokens.xs),
          Text(
            label,
            style: TextStyles.caption.copyWith(color: c.textSecondary),
          ),
        ],
      ),
    );
  }
}
