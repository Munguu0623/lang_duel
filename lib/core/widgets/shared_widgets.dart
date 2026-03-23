import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';

// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
// 🧩 Shared Widgets — reusable across all screens
// ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

// ─────────────────────────────────────────────────────
// Primary gradient button with press animation
// ─────────────────────────────────────────────────────
class AppButton extends StatefulWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = AppColors.primary,
    this.fullWidth = false,
    this.size = AppButtonSize.md,
    this.icon,
    this.enabled = true,
  });

  final String label;
  final VoidCallback onTap;
  final Color color;
  final bool fullWidth;
  final AppButtonSize size;
  final Widget? icon;
  final bool enabled;

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum AppButtonSize { sm, md, lg }

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _scale = Tween(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  EdgeInsets get _padding => switch (widget.size) {
    AppButtonSize.sm => const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    AppButtonSize.md => const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    AppButtonSize.lg => const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
  };

  double get _fontSize => switch (widget.size) {
    AppButtonSize.sm => 13,
    AppButtonSize.md => 15,
    AppButtonSize.lg => 17,
  };

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: GestureDetector(
        onTapDown: (_) => widget.enabled ? _ctrl.forward() : null,
        onTapUp: (_) {
          _ctrl.reverse();
          if (widget.enabled) widget.onTap();
        },
        onTapCancel: () => _ctrl.reverse(),
        child: Container(
          width: widget.fullWidth ? double.infinity : null,
          padding: _padding,
          decoration: BoxDecoration(
            gradient: widget.enabled
                ? LinearGradient(
                    colors: [widget.color, widget.color.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : null,
            color: widget.enabled ? null : AppColors.light,
            borderRadius: BorderRadius.circular(AppRadius.base),
            boxShadow: widget.enabled
                ? [
                    BoxShadow(
                      color: widget.color.withOpacity(0.3),
                      blurRadius: 16,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisSize: widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (widget.icon != null) ...[
                widget.icon!,
                const SizedBox(width: AppSpacing.sm),
              ],
              Text(
                widget.label,
                style: AppText.headingSm.copyWith(
                  color: AppColors.white,
                  fontSize: _fontSize,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Rounded card with soft shadow
// ─────────────────────────────────────────────────────
class AppCard extends StatelessWidget {
  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.onTap,
    this.color,
    this.border,
  });

  final Widget child;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Color? color;
  final Border? border;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: color ?? AppColors.white,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: border,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 20,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Small coloured pill badge (e.g. "B1", "Premium")
// ─────────────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  const AppBadge({
    super.key,
    required this.text,
    this.color = AppColors.accent,
    this.textColor = AppColors.dark,
  });

  final String text;
  final Color color;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        text,
        style: AppText.label.copyWith(
          color: textColor,
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Circular avatar with emoji and gradient background
// ─────────────────────────────────────────────────────
class AppAvatar extends StatelessWidget {
  const AppAvatar({
    super.key,
    this.size = 48,
    this.emoji = '😎',
    this.color = AppColors.primary,
    this.borderWidth = 3,
  });

  final double size;
  final String emoji;
  final Color color;
  final double borderWidth;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: AppColors.white, width: borderWidth),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: TextStyle(fontSize: size * 0.45)),
    );
  }
}

// ─────────────────────────────────────────────────────
// Animated progress bar
// ─────────────────────────────────────────────────────
class AppProgressBar extends StatelessWidget {
  const AppProgressBar({
    super.key,
    required this.value,
    this.max = 100,
    this.color = AppColors.primary,
    this.height = 10,
  });

  final double value;
  final double max;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) {
    final ratio = (value / max).clamp(0.0, 1.0);
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: AppColors.light,
        borderRadius: BorderRadius.circular(height),
      ),
      child: FractionallySizedBox(
        alignment: Alignment.centerLeft,
        widthFactor: ratio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, color.withOpacity(0.75)],
            ),
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Coin icon with optional amount
// ─────────────────────────────────────────────────────
class CoinIcon extends StatelessWidget {
  const CoinIcon({super.key, this.size = 20});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.gold,
        border: Border.all(color: const Color(0xFFF0932B), width: 1.5),
      ),
      alignment: Alignment.center,
      child: Text(
        'C',
        style: TextStyle(
          fontSize: size * 0.5,
          fontWeight: FontWeight.w900,
          color: const Color(0xFFE55039),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────
// Bottom navigation bar
// ─────────────────────────────────────────────────────
class AppBottomNav extends StatelessWidget {
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;

  static const _items = [
    _NavItem(icon: Icons.home_rounded, label: 'Home'),
    _NavItem(icon: Icons.sports_mma_rounded, label: 'Duels'),
    _NavItem(icon: Icons.emoji_events_rounded, label: 'Rank'),
    _NavItem(icon: Icons.person_rounded, label: 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.light)),
      ),
      padding: const EdgeInsets.only(top: 8, bottom: 12),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_items.length, (i) {
            final selected = i == currentIndex;
            return GestureDetector(
              onTap: () => onTap(i),
              behavior: HitTestBehavior.opaque,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedScale(
                    scale: selected ? 1.15 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      _items[i].icon,
                      color: selected ? AppColors.primary : AppColors.darkSoft,
                      size: 22,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _items[i].label,
                    style: AppText.label.copyWith(
                      color: selected ? AppColors.primary : AppColors.darkSoft,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
