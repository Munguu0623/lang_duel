import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';
import 'ghost_icon_button.dart';

/// Reusable top bar with optional back and action icon.
class TopBar extends StatelessWidget {
  const TopBar({
    super.key,
    required this.title,
    this.onBack,
    this.actionIcon,
    this.onAction,
  });

  final String title;
  final VoidCallback? onBack;
  final IconData? actionIcon;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.base,
        vertical: SpacingTokens.base,
      ),
      child: SizedBox(
        height: 56,
        child: Row(
          children: [
            if (onBack != null)
              GhostIconButton(
                icon: Icons.arrow_back_rounded,
                onTap: onBack,
              )
            else
              const SizedBox(width: 44),
            const SizedBox(width: SpacingTokens.md),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(width: SpacingTokens.md),
            if (actionIcon != null)
              GhostIconButton(
                icon: actionIcon!,
                onTap: onAction,
              )
            else
              const SizedBox(width: 44),
          ],
        ),
      ),
    );
  }
}
