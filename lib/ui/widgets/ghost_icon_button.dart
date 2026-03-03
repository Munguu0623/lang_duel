import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// 44x44 rounded-square icon button with subtle background and ripple.
class GhostIconButton extends StatelessWidget {
  const GhostIconButton({
    super.key,
    required this.icon,
    this.onTap,
  });

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Material(
      color: c.surfaceSecondary,
      borderRadius: RadiusTokens.small,
      child: InkWell(
        onTap: onTap,
        borderRadius: RadiusTokens.small,
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(icon, size: 20, color: c.textPrimary),
        ),
      ),
    );
  }
}
