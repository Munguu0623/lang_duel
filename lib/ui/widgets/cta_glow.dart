import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// Reusable radial glow behind CTA buttons.
/// Wraps a child (typically a [PrimaryButton]) with a blue-purple gradient.
class CtaGlow extends StatelessWidget {
  const CtaGlow({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          width: double.infinity,
          height: 88,
          decoration: BoxDecoration(
            gradient: RadialGradient(
              center: Alignment.center,
              radius: 1.4,
              colors: [
                c.primary.withValues(alpha: 0.10),
                c.accent.withValues(alpha: 0.04),
                Colors.transparent,
              ],
            ),
          ),
        ),
        SizedBox(width: double.infinity, child: child),
      ],
    );
  }
}
