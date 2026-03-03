import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/tokens.dart';
import 'pressable_scale.dart';

/// White elevated card with soft shadow and optional tap + leading icon.
class SoftCard extends StatefulWidget {
  const SoftCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(SpacingTokens.base),
    this.leadingIcon,
  });

  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final IconData? leadingIcon;

  @override
  State<SoftCard> createState() => _SoftCardState();
}

class _SoftCardState extends State<SoftCard> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (widget.onTap == null) return;
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final shadow = _pressed ? context.elevatedShadow : context.softShadow;

    final content = Padding(
      padding: widget.padding,
      child: widget.leadingIcon != null
          ? Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: c.primaryLight,
                    borderRadius: RadiusTokens.small,
                  ),
                  child: Icon(widget.leadingIcon,
                      size: 20, color: c.primary),
                ),
                const SizedBox(width: SpacingTokens.md),
                Expanded(child: widget.child),
              ],
            )
          : widget.child,
    );

    return AnimatedContainer(
      duration: MotionDurations.med,
      curve: MotionCurves.standard,
      decoration: BoxDecoration(
        color: c.surface,
        borderRadius: RadiusTokens.card,
        boxShadow: shadow,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: RadiusTokens.card,
        child: PressableScale(
          enabled: widget.onTap != null,
          onTap: widget.onTap,
          child: Listener(
            onPointerDown: (_) => _setPressed(true),
            onPointerUp: (_) => _setPressed(false),
            onPointerCancel: (_) => _setPressed(false),
            child: InkWell(
              onTap: widget.onTap,
              borderRadius: RadiusTokens.card,
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}
