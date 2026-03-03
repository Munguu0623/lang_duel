import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

enum StatPillVariant { neutral, primarySoft, successSoft }

/// Small pill for displaying rank, win rate, streak, or badge info.
class StatPill extends StatelessWidget {
  const StatPill({
    super.key,
    required this.label,
    this.icon,
    this.variant = StatPillVariant.neutral,
  });

  final String label;
  final IconData? icon;
  final StatPillVariant variant;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;

    final bg = switch (variant) {
      StatPillVariant.neutral => c.surfaceSecondary,
      StatPillVariant.primarySoft => c.primaryLight,
      StatPillVariant.successSoft => c.success.withValues(alpha: 0.1),
    };

    final fg = switch (variant) {
      StatPillVariant.neutral => c.textSecondary,
      StatPillVariant.primarySoft => c.primary,
      StatPillVariant.successSoft => c.success,
    };

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: SpacingTokens.md,
        vertical: SpacingTokens.xs,
      ),
      decoration: ShapeDecoration(color: bg, shape: const StadiumBorder()),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: fg),
            const SizedBox(width: SpacingTokens.xs),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: fg,
            ),
          ),
        ],
      ),
    );
  }
}
