import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';

/// Horizontal scrollable row of badge items with alternating colors.
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
    // Alternate: even=primaryLight/primary, odd=accentLight/accent
    final isEvenIndex = index.isEven;
    final bgColor = isEvenIndex ? c.primaryLight : c.accentLight;
    final fgColor = isEvenIndex ? c.primary : c.accent;
    final isCircle = isEvenIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: bgColor,
            shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
            borderRadius: isCircle ? null : RadiusTokens.medium,
            boxShadow: [
              BoxShadow(
                color: fgColor.withValues(alpha: 0.12),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Center(
            child: Icon(
              _iconForBadge(badge.icon),
              size: 22,
              color: fgColor,
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
