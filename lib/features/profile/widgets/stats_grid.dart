import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// Single row with VerticalDividers: Matches | Wins | Win Rate | Streak.
class StatsGrid extends StatelessWidget {
  const StatsGrid({
    super.key,
    required this.profile,
  });

  final ProfileData profile;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final winRate = profile.totalMatches > 0
        ? ((profile.wins / profile.totalMatches) * 100).round()
        : 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.card,
        boxShadow: context.softShadow,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
              child: _StatColumn(
                label: 'Matches',
                value: '${profile.totalMatches}',
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.border,
            ),
            Expanded(
              child: _StatColumn(
                label: 'Wins',
                value: '${profile.wins}',
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.border,
            ),
            Expanded(
              child: _StatColumn(
                label: 'Win Rate',
                value: '$winRate%',
              ),
            ),
            VerticalDivider(
              width: 1,
              thickness: 1,
              color: c.border,
            ),
            Expanded(
              child: _StatColumn(
                label: 'Streak',
                value: '${profile.user.streak}',
                icon: Icons.local_fire_department_rounded,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.label,
    required this.value,
    this.icon,
  });

  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null)
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 16, color: c.success),
              const SizedBox(width: 2),
              Text(
                value,
                style: TextStyles.statLarge.copyWith(
                  fontSize: 22,
                  color: c.textPrimary,
                ),
              ),
            ],
          )
        else
          Text(
            value,
            style: TextStyles.statLarge.copyWith(
              fontSize: 22,
              color: c.textPrimary,
            ),
          ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          label,
          style: TextStyles.caption.copyWith(color: c.textSecondary),
        ),
      ],
    );
  }
}
