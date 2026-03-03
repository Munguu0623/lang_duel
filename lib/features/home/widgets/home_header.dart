import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/ghost_icon_button.dart';

/// Compact top bar: notification + level badge + avatar.
/// Greeting moved to hero section for competitive feel.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.username,
    required this.level,
    required this.onNotificationTap,
  });

  final String username;
  final String level;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Row(
      children: [
        GhostIconButton(
          icon: Icons.notifications_none_rounded,
          onTap: onNotificationTap,
        ),
        const SizedBox(width: SpacingTokens.sm),
        // Level badge — minimal, secondary
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: SpacingTokens.md,
            vertical: SpacingTokens.xs,
          ),
          decoration: BoxDecoration(
            color: c.surfaceSecondary,
            borderRadius: RadiusTokens.pill,
          ),
          child: Text(
            level,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: c.textSecondary,
            ),
          ),
        ),
        const Spacer(),
        DuelAvatar(name: username, size: 40),
      ],
    );
  }
}
