import 'package:flutter/material.dart';

import '../../core/motion/motion.dart';
import '../../core/theme/tokens.dart';
import 'haptics.dart';
import 'pressable_scale.dart';

enum ButtonSize { sm, md, lg }

/// Primary action button with gradient, colored shadow, and loading state.
class PrimaryButton extends StatefulWidget {
  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.expanded = true,
    this.size = ButtonSize.md,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool expanded;
  final ButtonSize size;
  final bool isLoading;

  @override
  State<PrimaryButton> createState() => _PrimaryButtonState();
}

class _PrimaryButtonState extends State<PrimaryButton> {
  bool _pressed = false;

  double get _height => switch (widget.size) {
        ButtonSize.sm => 44,
        ButtonSize.md => 48,
        ButtonSize.lg => 56,
      };

  double get _fontSize => switch (widget.size) {
        ButtonSize.sm => 14,
        ButtonSize.md => 16,
        ButtonSize.lg => 18,
      };

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final enabled = !widget.isLoading && widget.onPressed != null;
    final glowOpacity = _pressed && enabled ? 0.4 : 0.25;

    final button = PressableScale(
      enabled: enabled,
      onTap: enabled
          ? () async {
              await Haptics.lightTap();
              widget.onPressed?.call();
            }
          : null,
      child: Listener(
        onPointerDown: (_) {
          if (enabled) setState(() => _pressed = true);
        },
        onPointerUp: (_) => setState(() => _pressed = false),
        onPointerCancel: (_) => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: MotionDurations.fast,
          height: _height,
          decoration: BoxDecoration(
            gradient: enabled
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [c.primary, c.primaryDark],
                  )
                : null,
            color: enabled ? null : c.surfaceSecondary,
            borderRadius: RadiusTokens.pill,
            boxShadow: enabled ? ElevationTokens.primaryGlow(glowOpacity) : null,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: MotionDurations.med,
              child: widget.isLoading
                  ? SizedBox(
                      key: const ValueKey('loading'),
                      width: _fontSize + 4,
                      height: _fontSize + 4,
                      child: const CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      key: const ValueKey('label'),
                      widget.label,
                      style: TextStyle(
                        fontSize: _fontSize,
                        fontWeight: FontWeight.w700,
                        color: enabled ? Colors.white : c.textSecondary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );

    return widget.expanded
        ? SizedBox(width: double.infinity, child: button)
        : button;
  }
}
