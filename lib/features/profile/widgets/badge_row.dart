import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// Horizontal scrollable row of badge items.
class BadgeRow extends StatelessWidget {
  const BadgeRow({
    super.key,
    required this.badges,
  });

  final List<DuelBadge> badges;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: badges.length,
        separatorBuilder: (_, _) => const SizedBox(width: SpacingTokens.md),
        itemBuilder: (_, index) =>
            _BadgeItem(badge: badges[index], index: index),
      ),
    );
  }
}

class _BadgeItem extends StatelessWidget {
  const _BadgeItem({required this.badge, required this.index});

  final DuelBadge badge;
  final int index;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    // Alternate badge shapes: even = circle, odd = squircle
    final isCircle = index.isEven;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: c.primaryLight,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : RadiusTokens.medium,
          ),
          child: Center(
            child: Icon(
              _iconForBadge(badge.icon),
              size: 22,
              color: c.primary,
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          badge.label,
          style: TextStyles.caption.copyWith(color: c.textSecondary),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  IconData _iconForBadge(String icon) {
    return switch (icon) {
      '1' => Icons.emoji_events_rounded,
      '2' => Icons.local_fire_department_rounded,
      '3' => Icons.record_voice_over_rounded,
      '4' => Icons.forum_rounded,
      '5' => Icons.spellcheck_rounded,
      _ => Icons.star_rounded,
    };
  }
}
