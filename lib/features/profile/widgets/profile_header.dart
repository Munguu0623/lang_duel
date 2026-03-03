import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../mock/fake_models.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/stat_pill.dart';

/// Large avatar + username + rank/level/win-rate badges.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({
    super.key,
    required this.user,
  });

  final DuelUser user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DuelAvatar(name: user.name, size: 88, showRing: true),
        const SizedBox(height: SpacingTokens.md),
        Text(user.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: SpacingTokens.sm),
        // Badges row
        Wrap(
          spacing: SpacingTokens.sm,
          runSpacing: SpacingTokens.xs,
          alignment: WrapAlignment.center,
          children: [
            StatPill(
              icon: Icons.shield_rounded,
              label: user.rank,
              variant: StatPillVariant.primarySoft,
            ),
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
