import 'package:flutter/material.dart';

import '../../core/theme/tokens.dart';

/// Circular avatar with pastel fallback, optional badge, and optional ring.
class DuelAvatar extends StatelessWidget {
  const DuelAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 48,
    this.badge,
    this.showRing = false,
  });

  final String name;
  final String? imageUrl;
  final double size;
  final Widget? badge;

  /// Shows a primary-colored ring around the avatar (e.g. for premium users).
  final bool showRing;

  static const _pastelColors = [
    Color(0xFFE8DEFF),
    Color(0xFFDEF0FF),
    Color(0xFFFFE8DE),
    Color(0xFFDEFFE8),
    Color(0xFFFFF2DE),
    Color(0xFFFFDEE8),
  ];

  Color get _bgColor {
    final index = name.isEmpty ? 0 : name.codeUnitAt(0) % _pastelColors.length;
    return _pastelColors[index];
  }

  @override
  Widget build(BuildContext context) {
    final c = context.colors;
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;
    final initial = name.isEmpty ? '?' : name[0].toUpperCase();
    final ringWidth = showRing ? 2.5 : 0.0;

    return SizedBox(
      width: size + ringWidth * 2,
      height: size + ringWidth * 2,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            decoration: showRing
                ? BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: c.primary,
                      width: ringWidth,
                    ),
                  )
                : null,
            padding: EdgeInsets.all(ringWidth),
            child: CircleAvatar(
              radius: size / 2,
              backgroundColor: hasImage ? null : _bgColor,
              backgroundImage: hasImage ? NetworkImage(imageUrl!) : null,
              child: hasImage
                  ? null
                  : Text(
                      initial,
                      style: TextStyle(
                        fontSize: size * 0.4,
                        fontWeight: FontWeight.w600,
                        color: c.textPrimary,
                      ),
                    ),
            ),
          ),
          if (badge != null)
            Positioned(right: -2, bottom: -2, child: badge!),
        ],
      ),
    );
  }
}
