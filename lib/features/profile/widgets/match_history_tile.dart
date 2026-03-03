import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';

/// Single match history row — opponent, result, score, date.
class MatchHistoryTile extends StatelessWidget {
  const MatchHistoryTile({
    super.key,
    required this.match,
  });

  final RecentMatch match;

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final resultColor = match.didWin ? c.success : c.danger;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.md,
      ),
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.medium,
        boxShadow: context.softShadow,
      ),
      child: Row(
        children: [
          DuelAvatar(name: match.opponent.name, size: 40),
          const SizedBox(width: SpacingTokens.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  match.opponent.name,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  _formatDate(match.createdAt),
                  style: TextStyles.caption.copyWith(color: c.textSecondary),
                ),
              ],
            ),
          ),
          // Result + score
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: SpacingTokens.sm,
                  vertical: 2,
                ),
                decoration: ShapeDecoration(
                  color: resultColor.withValues(alpha: 0.1),
                  shape: const StadiumBorder(),
                ),
                child: Text(
                  match.didWin ? 'Win' : 'Loss',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: resultColor,
                  ),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${match.yourScore}-${match.theirScore}',
                style: TextStyles.caption.copyWith(color: c.textSecondary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
