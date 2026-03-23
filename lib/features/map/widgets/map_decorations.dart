import 'package:flutter/material.dart';

/// Fluffy cloud decoration drawn with overlapping circles.
class CloudDecoration extends StatelessWidget {
  const CloudDecoration({
    super.key,
    this.size = 1.0,
    this.opacity = 0.5,
  });

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: SizedBox(
        width: 70 * size,
        height: 30 * size,
        child: CustomPaint(painter: _CloudPainter(size)),
      ),
    );
  }
}

class _CloudPainter extends CustomPainter {
  _CloudPainter(this.scale);
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    final s = scale;
    canvas.drawCircle(Offset(15 * s, 18 * s), 12 * s, paint);
    canvas.drawCircle(Offset(30 * s, 12 * s), 16 * s, paint);
    canvas.drawCircle(Offset(48 * s, 16 * s), 13 * s, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Twinkling sparkle with animation.
class SparkleDecoration extends StatefulWidget {
  const SparkleDecoration({super.key});

  @override
  State<SparkleDecoration> createState() => _SparkleDecorationState();
}

class _SparkleDecorationState extends State<SparkleDecoration>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: Tween(begin: 0.3, end: 0.9).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
      ),
      child: const Text('✨', style: TextStyle(fontSize: 12)),
    );
  }
}

/// Positioned tree/plant emoji decoration.
class TreeDecoration extends StatelessWidget {
  const TreeDecoration({super.key, this.type = 0});

  /// 0 = 🌳, 1 = 🌴, 2 = 🌿
  final int type;

  static const _emojis = ['🌳', '🌴', '🌿'];
  static const _sizes = [18.0, 16.0, 14.0];

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.55,
      child: Text(
        _emojis[type % _emojis.length],
        style: TextStyle(fontSize: _sizes[type % _sizes.length]),
      ),
    );
  }
}

/// The zigzag positions for each stage node.
/// Returns a left-offset percentage (0–100) for each stage index.
class StagePositions {
  StagePositions._();

  static const List<double> _xPercents = [
    50, 72, 45, 25, 50, 70, 40, 22, 58, 50,
  ];

  /// Horizontal position as a fraction of container width.
  static double xFraction(int index) =>
      _xPercents[index % _xPercents.length] / 100;

  /// Vertical spacing between nodes (in logical pixels).
  static const double nodeSpacing = 105;
}
