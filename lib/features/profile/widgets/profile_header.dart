import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/stat_pill.dart';

/// Large avatar + rank dominant + username + level/win-rate pills.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final DuelUser user;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Column(
      children: [
        DuelAvatar(name: user.name, size: 88, showRing: true),
        const SizedBox(height: SpacingTokens.md),
        // Rank dominant — big number
        Text(
          user.rank,
          style: TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: c.primary,
            fontFeatures: const [FontFeature.tabularFigures()],
          ),
        ),
        Text(
          'Global Rank',
          style: TextStyles.caption.copyWith(color: c.textSecondary),
        ),
        const SizedBox(height: SpacingTokens.sm),
        Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: SpacingTokens.sm),
        // Smaller pills below
        Wrap(
          spacing: SpacingTokens.sm,
          runSpacing: SpacingTokens.xs,
          alignment: WrapAlignment.center,
          children: [
            StatPill(
              icon: Icons.school_rounded,
              label: user.level,
            ),
            StatPill(
              icon: Icons.percent_rounded,
              label: '${(user.winRate * 100).round()}%',
              variant: StatPillVariant.successSoft,
            ),
          ],
        ),
      ],
    );
  }
}
