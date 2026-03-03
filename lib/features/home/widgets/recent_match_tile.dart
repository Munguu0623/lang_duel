import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';

/// Single match tile — clean list style with subtle win/loss and rank movement.
/// Borderless with divider separator.
class RecentMatchTile extends StatelessWidget {
  const RecentMatchTile({
    super.key,
    required this.match,
    required this.onTap,
  });

  final RecentMatch match;
  final VoidCallback onTap;

  String _timeAgo(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final resultColor = match.didWin ? c.success : c.danger;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.base,
          vertical: SpacingTokens.md,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: c.border, width: 0.5),
          ),
        ),
        child: Row(
          children: [
            DuelAvatar(name: match.opponent.name, size: 44),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'vs ${match.opponent.name}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: SpacingTokens.xs),
                  Row(
                    children: [
                      // Result chip
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
                      const SizedBox(width: SpacingTokens.sm),
                      // Score
                      Text(
                        '${match.yourScore}-${match.theirScore}',
                        style: TextStyles.caption
                            .copyWith(color: c.textSecondary),
                      ),
                      const SizedBox(width: SpacingTokens.sm),
                      // Time ago
                      Text(
                        _timeAgo(match.createdAt),
                        style: TextStyles.caption
                            .copyWith(color: c.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Rank movement indicator
            if (match.rankChange != 0) ...[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 6,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: (match.rankChange > 0 ? c.success : c.danger)
                      .withValues(alpha: 0.1),
                  borderRadius: RadiusTokens.pill,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      match.rankChange > 0
                          ? Icons.arrow_upward_rounded
                          : Icons.arrow_downward_rounded,
                      size: 10,
                      color:
                          match.rankChange > 0 ? c.success : c.danger,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      '${match.rankChange.abs()}',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color:
                            match.rankChange > 0 ? c.success : c.danger,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: SpacingTokens.sm),
            ],
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: c.textTertiary,
            ),
          ],
        ),
      ),
    );
  }
}
