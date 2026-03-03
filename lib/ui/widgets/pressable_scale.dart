import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';

/// Wrapper that adds subtle press-scale to any child.
class PressableScale extends StatefulWidget {
  const PressableScale({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
    this.scaleFactor = 0.97,
  });

  final Widget child;
  final VoidCallback? onTap;
  final bool enabled;
  final double scaleFactor;

  @override
  State<PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (!widget.enabled) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final targetScale = _pressed && widget.enabled ? widget.scaleFactor : 1.0;
    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.enabled ? widget.onTap : null,
      behavior: HitTestBehavior.translucent,
      child: AnimatedScale(
        scale: targetScale,
        duration: MotionDurations.fast,
        curve: MotionCurves.standard,
        child: widget.child,
      ),
    );
  }
}

