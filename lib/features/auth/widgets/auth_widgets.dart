import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// Auth Shared Widgets — input, button, password meter
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

/// Styled text input with icon, label, and error state.
class AuthInput extends StatefulWidget {
  const AuthInput({
    super.key,
    required this.controller,
    this.label,
    this.placeholder,
    this.icon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.errorText,
    this.onChanged,
  });

  final TextEditingController controller;
  final String? label;
  final String? placeholder;
  final IconData? icon;
  final bool isPassword;
  final TextInputType keyboardType;
  final String? errorText;
  final ValueChanged<String>? onChanged;

  @override
  State<AuthInput> createState() => _AuthInputState();
}

class _AuthInputState extends State<AuthInput> {
  bool _obscure = true;
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null && widget.errorText!.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label
          if (widget.label != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(widget.label!, style: AppText.label),
            ),

          // Input container
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(AppRadius.input),
              border: Border.all(
                color: hasError
                    ? AppColors.danger
                    : _focused
                        ? AppColors.primary
                        : AppColors.light,
                width: 2.5,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.1),
                        blurRadius: 12,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Row(
              children: [
                // Icon
                if (widget.icon != null)
                  Padding(
                    padding: const EdgeInsets.only(left: 14),
                    child: Icon(widget.icon, size: 18, color: AppColors.darkSoft.withOpacity(0.5)),
                  ),

                // Text field
                Expanded(
                  child: Focus(
                    onFocusChange: (f) => setState(() => _focused = f),
                    child: TextField(
                      controller: widget.controller,
                      obscureText: widget.isPassword && _obscure,
                      keyboardType: widget.keyboardType,
                      onChanged: widget.onChanged,
                      style: AppText.bodyMd.copyWith(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: widget.placeholder,
                        hintStyle: AppText.bodyMd.copyWith(
                          color: AppColors.darkSoft.withOpacity(0.4),
                          fontSize: 14,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                      ),
                    ),
                  ),
                ),

                // Password visibility toggle
                if (widget.isPassword)
                  GestureDetector(
                    onTap: () => setState(() => _obscure = !_obscure),
                    child: Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(
                        _obscure ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        size: 20,
                        color: AppColors.darkSoft.withOpacity(0.4),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Error text
          if (hasError)
            Padding(
              padding: const EdgeInsets.only(top: 4, left: 4),
              child: Text(widget.errorText!, style: AppText.error),
            ),
        ],
      ),
    );
  }
}

/// Primary button with 3D shadow effect and press animation.
class AuthButton extends StatefulWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
    this.loading = false,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool loading;
  final bool enabled;

  @override
  State<AuthButton> createState() => _AuthButtonState();
}

class _AuthButtonState extends State<AuthButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final isActive = widget.enabled && !widget.loading;

    return GestureDetector(
      onTapDown: (_) => isActive ? setState(() => _pressed = true) : null,
      onTapUp: (_) {
        setState(() => _pressed = false);
        if (isActive) widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        height: 52,
        width: double.infinity,
        transform: Matrix4.translationValues(0, _pressed ? 2 : 0, 0),
        decoration: BoxDecoration(
          color: isActive ? widget.color : AppColors.light,
          borderRadius: BorderRadius.circular(AppRadius.button),
          boxShadow: _pressed || !isActive
              ? []
              : [
                  BoxShadow(
                    color: widget.color.withOpacity(0.35),
                    blurRadius: 14,
                    offset: const Offset(0, 4),
                  ),
                ],
        ),
        child: Stack(
          children: [
            // 3D bottom shadow
            if (isActive)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.15),
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(14),
                    ),
                  ),
                ),
              ),

            // Label
            Center(
              child: widget.loading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation(AppColors.white),
                      ),
                    )
                  : Text(
                      widget.label,
                      style: AppText.headingSm.copyWith(
                        color: isActive ? AppColors.white : AppColors.darkSoft,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Password strength indicator (5 bars).
class PasswordStrength extends StatelessWidget {
  const PasswordStrength({super.key, required this.password});

  final String password;

  int get _strength {
    if (password.isEmpty) return 0;
    int s = 0;
    if (password.length >= 6) s++;
    if (password.length >= 8) s++;
    if (password.contains(RegExp(r'[A-Z]'))) s++;
    if (password.contains(RegExp(r'[0-9]'))) s++;
    if (password.contains(RegExp(r'[^A-Za-z0-9]'))) s++;
    return s;
  }

  static const _labels = ['', 'Маш сул', 'Сул', 'Дунд', 'Сайн', 'Маш сайн'];
  static const _colors = [
    AppColors.light,
    AppColors.danger,
    AppColors.accentOrange,
    AppColors.accent,
    AppColors.secondary,
    AppColors.parrotGreen,
  ];

  @override
  Widget build(BuildContext context) {
    if (password.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Bars
          Row(
            children: List.generate(5, (i) {
              return Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  margin: EdgeInsets.only(right: i < 4 ? 4 : 0),
                  decoration: BoxDecoration(
                    color: i < _strength ? _colors[_strength] : AppColors.light,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 4),

          // Label
          Text(
            _labels[_strength],
            style: AppText.error.copyWith(color: _colors[_strength]),
          ),
        ],
      ),
    );
  }
}

/// Text divider with centered label (e.g. "эсвэл").
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key, this.text = 'эсвэл'});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        children: [
          const Expanded(child: Divider(thickness: 1.5, color: AppColors.light)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(text, style: AppText.bodySm.copyWith(fontWeight: FontWeight.w700)),
          ),
          const Expanded(child: Divider(thickness: 1.5, color: AppColors.light)),
        ],
      ),
    );
  }
}

/// Floating decorative circles for background.
class FloatingDecorations extends StatelessWidget {
  const FloatingDecorations({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -30, right: -30,
          child: _circle(120, AppColors.accent.withOpacity(0.12)),
        ),
        Positioned(
          bottom: 40, left: -20,
          child: _circle(80, AppColors.secondary.withOpacity(0.08)),
        ),
        Positioned(
          top: 120, left: -35,
          child: _circle(60, AppColors.primary.withOpacity(0.06)),
        ),
      ],
    );
  }

  Widget _circle(double size, Color color) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
      );
}

/// Top brand bar: 🎙️ LANGDUEL
class BrandHeader extends StatelessWidget {
  const BrandHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('🎙️', style: TextStyle(fontSize: 20)),
            const SizedBox(width: 6),
            Text('LANGDUEL', style: AppText.brand),
          ],
        ),
      ),
    );
  }
}
