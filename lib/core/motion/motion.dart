import 'package:flutter/material.dart';

/// Motion system: shared durations, curves, and simple helpers.
abstract final class MotionDurations {
  static const fast = Duration(milliseconds: 140);
  static const med = Duration(milliseconds: 180);
  static const slow = Duration(milliseconds: 240);
  static const countdownTick = Duration(milliseconds: 220);
}

abstract final class MotionCurves {
  static const standard = Curves.easeOutCubic;
  static const enter = Curves.easeOut;
  static const exit = Curves.easeIn;
}

/// Fade + slight upward slide transition wrapper.
class FadeSlideTransition extends StatelessWidget {
  const FadeSlideTransition({
    super.key,
    required this.animation,
    required this.child,
    this.offset = const Offset(0, 0.03),
  });

  final Animation<double> animation;
  final Widget child;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    final curved = CurvedAnimation(
      parent: animation,
      curve: MotionCurves.enter,
      reverseCurve: MotionCurves.exit,
    );
    return FadeTransition(
      opacity: curved,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: offset,
          end: Offset.zero,
        ).animate(curved),
        child: child,
      ),
    );
  }
}

/// Count-up text for scores (integer only).
class CountUpText extends StatelessWidget {
  const CountUpText({
    super.key,
    required this.value,
    required this.style,
  });

  final int value;
  final TextStyle style;

  Duration get _duration {
    final ms = (value * 8).clamp(200, 600);
    return Duration(milliseconds: ms);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<int>(
      tween: IntTween(begin: 0, end: value),
      duration: _duration,
      curve: MotionCurves.standard,
      builder: (context, current, _) {
        return Text(
          '$current',
          style: style,
        );
      },
    );
  }
}

