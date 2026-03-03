import 'package:flutter/material.dart';

import '../../../core/theme/tokens.dart';
import '../../../ui/widgets/duel_avatar.dart';
import '../../../ui/widgets/ghost_icon_button.dart';

/// Top section: notification icon + greeting + avatar.
class HomeHeader extends StatelessWidget {
  const HomeHeader({
    super.key,
    required this.username,
    required this.onNotificationTap,
  });

  final String username;
  final VoidCallback onNotificationTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top row — notification + avatar
        Row(
          children: [
            GhostIconButton(
              icon: Icons.notifications_none_rounded,
              onTap: onNotificationTap,
            ),
            const Spacer(),
            DuelAvatar(name: username, size: 40),
          ],
        ),
        const SizedBox(height: SpacingTokens.lg),
        // Greeting
        Text(
          'Hello,',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        Text(
          username,
          style: Theme.of(context).textTheme.headlineLarge,
        ),
      ],
    );
  }
}
