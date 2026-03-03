import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_data.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';

/// Single row in the leaderboard list.
/// Current user row gets primaryLight highlight; others are borderless + divider.
class LeaderboardTile extends StatelessWidget {
  const LeaderboardTile({
    super.key,
    required this.entry,
  });

  final LeaderboardEntry entry;

  bool get _isCurrentUser => entry.user.id == FakeData.currentUser.id;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      decoration: BoxDecoration(
        color: _isCurrentUser ? c.primaryLight : null,
        borderRadius: _isCurrentUser ? RadiusTokens.medium : null,
        border: _isCurrentUser
            ? null
            : Border(bottom: BorderSide(color: c.border, width: 0.5)),
      ),
      child: Row(
        children: [
          // Rank number
          SizedBox(
            width: 32,
            child: Text(
              '#${entry.rank}',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: _isCurrentUser ? c.primary : c.textSecondary,
              ),
            ),
          ),
          DuelAvatar(name: entry.user.name, size: 36),
          const SizedBox(width: SpacingTokens.md),
          // Name + level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.user.name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight:
                        _isCurrentUser ? FontWeight.w600 : FontWeight.w500,
                    color: c.textPrimary,
                  ),
                ),
                Text(
                  entry.user.level,
                  style: TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          // Win rate — accent color
          Text(
            '${(entry.user.winRate * 100).round()}%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: c.accent,
            ),
          ),
        ],
      ),
    );
  }
}
