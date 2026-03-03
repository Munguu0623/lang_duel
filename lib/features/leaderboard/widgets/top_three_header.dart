import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';

/// Special podium layout: 2nd (left) — 1st (center, bigger) — 3rd (right).
/// Gold / Silver / Bronze colors per rank.
class TopThreeHeader extends StatelessWidget {
  const TopThreeHeader({
    super.key,
    required this.entries,
  });

  /// Must contain exactly 3 entries, already sorted by rank.
  final List<LeaderboardEntry> entries;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _PodiumItem(
          entry: entries[1],
          podiumHeight: 72,
          avatarSize: 48,
          color: c.silver,
          colorSoft: c.silverSoft,
        ),
        const SizedBox(width: SpacingTokens.md),
        _PodiumItem(
          entry: entries[0],
          podiumHeight: 96,
          avatarSize: 60,
          color: c.gold,
          colorSoft: c.goldSoft,
        ),
        const SizedBox(width: SpacingTokens.md),
        _PodiumItem(
          entry: entries[2],
          podiumHeight: 56,
          avatarSize: 48,
          color: c.bronze,
          colorSoft: c.bronzeSoft,
        ),
      ],
    );
  }
}

class _PodiumItem extends StatelessWidget {
  const _PodiumItem({
    required this.entry,
    required this.podiumHeight,
    required this.avatarSize,
    required this.color,
    required this.colorSoft,
  });

  final LeaderboardEntry entry;
  final double podiumHeight;
  final double avatarSize;
  final Color color;
  final Color colorSoft;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Rank badge
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
        const SizedBox(height: SpacingTokens.xs),
        DuelAvatar(name: entry.user.name, size: avatarSize),
        const SizedBox(height: SpacingTokens.xs),
        Text(
          entry.user.name.split(' ').first,
          style: TextStyles.labelLarge.copyWith(color: c.textPrimary),
        ),
        Text(
          entry.user.level,
          style: TextStyles.caption.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: SpacingTokens.xs),
        // Podium bar
        Container(
          width: 80,
          height: podiumHeight,
          decoration: BoxDecoration(
            color: colorSoft,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(12),
            ),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              '${entry.user.rating}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
