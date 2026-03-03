import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

class SoftChip extends StatelessWidget {
  const SoftChip({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: DurationTokens.normal,
        padding: const EdgeInsets.symmetric(
          horizontal: SpacingTokens.base,
          vertical: SpacingTokens.sm,
        ),
        decoration: ShapeDecoration(
          color: selected ? c.primary : c.surface,
          shape: StadiumBorder(
            side: selected
                ? BorderSide.none
                : BorderSide(color: c.border),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? Colors.white : c.textSecondary,
          ),
        ),
      ),
    );
  }
}
