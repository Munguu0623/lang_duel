import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';

/// Horizontal scrollable strip of live social/activity indicators.
/// Creates FOMO and competitive energy: challenges, rankings, quests.
class SocialEnergyStrip extends StatelessWidget {
  const SocialEnergyStrip({super.key});

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        clipBehavior: Clip.none,
        children: [
          _EnergyChip(
            icon: Icons.sports_mma_rounded,
            label: '2 new challenges',
            color: c.warning,
          ),
          const SizedBox(width: SpacingTokens.sm),
          _EnergyChip(
            icon: Icons.emoji_events_rounded,
            label: 'Top 10 this week',
            color: c.gold,
          ),
          const SizedBox(width: SpacingTokens.sm),
          _EnergyChip(
            icon: Icons.track_changes_rounded,
            label: 'Daily quest 80%',
            color: c.success,
          ),
          const SizedBox(width: SpacingTokens.sm),
          _EnergyChip(
            icon: Icons.trending_up_rounded,
            label: 'Moved up 3 places',
            color: c.accent,
          ),
        ],
      ),
    );
  }
}

/// Single energy chip — icon + label with subtle border.
class _EnergyChip extends StatelessWidget {
  const _EnergyChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.sm,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.pill,
        border: Border.all(color: c.border, width: 0.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: SpacingTokens.xs),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
