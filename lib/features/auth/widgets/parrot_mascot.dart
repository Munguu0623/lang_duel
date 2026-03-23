import 'package:flutter/material.dart';
import 'package:voice_duel/core/theme/app_theme.dart';

/// Parrot mascot moods — affects eye/beak expression.
enum ParrotMood { happy, wink, think }

/// LangDuel Parrot Mascot widget.
///
/// A cartoon parrot wearing headphones and holding a microphone.
/// Supports 3 moods: [happy], [wink], [think].
///
/// Usage:
/// ```dart
/// ParrotMascot(size: 120, mood: ParrotMood.happy)
/// ```
class ParrotMascot extends StatelessWidget {
  const ParrotMascot({
    super.key,
    this.size = 140,
    this.mood = ParrotMood.happy,
  });

  final double size;
  final ParrotMood mood;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _ParrotPainter(mood: mood),
      ),
    );
  }
}

class _ParrotPainter extends CustomPainter {
  _ParrotPainter({required this.mood});

  final ParrotMood mood;

  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 140; // scale factor

    // ── Helper paints ──
    Paint fill(Color c) => Paint()..color = c..style = PaintingStyle.fill;
    Paint stroke(Color c, double w) =>
        Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = w * s..strokeCap = StrokeCap.round;

    // ── Background circle ──
    canvas.drawCircle(
      Offset(70 * s, 68 * s), 52 * s,
      fill(AppColors.primary.withOpacity(0.12)),
    );

    // ── Tail feathers ──
    _drawPath(canvas, [
      [48, 105], [35, 120], [30, 130], [38, 125], [45, 115],
    ], s, fill(AppColors.parrotBlue));
    _drawPath(canvas, [
      [52, 108], [42, 125], [38, 135], [46, 128], [52, 118],
    ], s, fill(AppColors.parrotGreen));

    // ── Body ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(70 * s, 92 * s), width: 56 * s, height: 64 * s),
      fill(AppColors.parrotGreen),
    );
    canvas.drawOval(
      Rect.fromCenter(center: Offset(70 * s, 92 * s), width: 56 * s, height: 64 * s),
      stroke(const Color(0xFF1D8044), 2),
    );

    // ── Belly ──
    canvas.drawOval(
      Rect.fromCenter(center: Offset(70 * s, 100 * s), width: 36 * s, height: 40 * s),
      fill(AppColors.parrotYellow.withOpacity(0.7)),
    );

    // ── Wings ──
    _drawWing(canvas, s, isLeft: true);
    _drawWing(canvas, s, isLeft: false);

    // ── Microphone ──
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(108 * s, 56 * s, 6 * s, 20 * s),
        Radius.circular(3 * s),
      ),
      fill(const Color(0xFF555555)),
    );
    canvas.drawCircle(Offset(111 * s, 52 * s), 7 * s, fill(const Color(0xFF333333)));
    canvas.drawLine(
      Offset(105 * s, 52 * s), Offset(117 * s, 52 * s),
      stroke(const Color(0xFF777777), 0.5),
    );

    // ── Head ──
    canvas.drawCircle(Offset(70 * s, 48 * s), 28 * s, fill(AppColors.parrotGreenLight));
    canvas.drawCircle(Offset(70 * s, 48 * s), 28 * s, stroke(const Color(0xFF1D8044), 2));

    // ── Head feathers ──
    _drawFeather(canvas, 62, 24, -12, s, AppColors.danger);
    _drawFeather(canvas, 70, 21, 0, s, AppColors.parrotOrange);
    _drawFeather(canvas, 78, 24, 12, s, AppColors.primary);

    // ── Headphones ──
    final hpPath = Path()
      ..moveTo(44 * s, 42 * s)
      ..quadraticBezierTo(44 * s, 20 * s, 70 * s, 18 * s)
      ..quadraticBezierTo(96 * s, 20 * s, 96 * s, 42 * s);
    canvas.drawPath(hpPath, stroke(const Color(0xFF333333), 3.5));

    // Left ear cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(36 * s, 36 * s, 12 * s, 16 * s), Radius.circular(4 * s)),
      fill(const Color(0xFF333333)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(38 * s, 39 * s, 8 * s, 10 * s), Radius.circular(3 * s)),
      fill(const Color(0xFF555555)),
    );

    // Right ear cup
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(92 * s, 36 * s, 12 * s, 16 * s), Radius.circular(4 * s)),
      fill(const Color(0xFF333333)),
    );
    canvas.drawRRect(
      RRect.fromRectAndRadius(Rect.fromLTWH(94 * s, 39 * s, 8 * s, 10 * s), Radius.circular(3 * s)),
      fill(const Color(0xFF555555)),
    );

    // ── Eyes ──
    _drawEyes(canvas, s);

    // ── Beak ──
    final beakPath = Path()
      ..moveTo(65 * s, 54 * s)
      ..lineTo(70 * s, 64 * s)
      ..lineTo(75 * s, 54 * s)
      ..close();
    canvas.drawPath(beakPath, fill(AppColors.parrotOrange));
    canvas.drawPath(beakPath, stroke(const Color(0xFFD68910), 1.5));

    if (mood == ParrotMood.happy) {
      final smilePath = Path()
        ..moveTo(64 * s, 62 * s)
        ..quadraticBezierTo(70 * s, 68 * s, 76 * s, 62 * s);
      canvas.drawPath(smilePath, stroke(const Color(0xFFD68910), 1.5));
    }

    // ── Blush ──
    canvas.drawCircle(Offset(50 * s, 54 * s), 5 * s, fill(const Color(0xFFFD79A8).withOpacity(0.25)));
    canvas.drawCircle(Offset(90 * s, 54 * s), 5 * s, fill(const Color(0xFFFD79A8).withOpacity(0.25)));

    // ── Feet ──
    _drawFoot(canvas, 58, 122, s);
    _drawFoot(canvas, 82, 122, s);
  }

  void _drawEyes(Canvas canvas, double s) {
    final fill_ = (Color c) => Paint()..color = c..style = PaintingStyle.fill;
    final stroke_ = (Color c, double w) =>
        Paint()..color = c..style = PaintingStyle.stroke..strokeWidth = w * s..strokeCap = StrokeCap.round;

    switch (mood) {
      case ParrotMood.happy:
      case ParrotMood.think:
        // Both eyes open
        canvas.drawCircle(Offset(60 * s, 44 * s), 8 * s, fill_(AppColors.white));
        canvas.drawCircle(Offset(80 * s, 44 * s), 8 * s, fill_(AppColors.white));
        final pupilSize = mood == ParrotMood.think ? 5.0 : 4.5;
        canvas.drawCircle(Offset(62 * s, 42 * s), pupilSize * s, fill_(AppColors.dark));
        canvas.drawCircle(Offset(82 * s, 42 * s), pupilSize * s, fill_(AppColors.dark));
        canvas.drawCircle(Offset(63.5 * s, 40.5 * s), 1.8 * s, fill_(AppColors.white));
        canvas.drawCircle(Offset(83.5 * s, 40.5 * s), 1.8 * s, fill_(AppColors.white));
        break;

      case ParrotMood.wink:
        // Left eye open
        canvas.drawCircle(Offset(60 * s, 44 * s), 8 * s, fill_(AppColors.white));
        canvas.drawCircle(Offset(62 * s, 42 * s), 4.5 * s, fill_(AppColors.dark));
        canvas.drawCircle(Offset(63.5 * s, 40.5 * s), 1.8 * s, fill_(AppColors.white));
        // Right eye winking
        final winkPath = Path()
          ..moveTo(74 * s, 44 * s)
          ..quadraticBezierTo(80 * s, 38 * s, 86 * s, 44 * s);
        canvas.drawPath(winkPath, stroke_(AppColors.dark, 2.5));
        break;
    }
  }

  void _drawWing(Canvas canvas, double s, {required bool isLeft}) {
    final fill_ = (Color c) => Paint()..color = c..style = PaintingStyle.fill;

    if (isLeft) {
      _drawPath(canvas, [[42, 82], [30, 75], [28, 68], [35, 72], [42, 78]], s, fill_(AppColors.parrotGreenLight));
      _drawPath(canvas, [[44, 88], [28, 84], [24, 78], [32, 82], [42, 84]], s, fill_(AppColors.parrotGreen));
    } else {
      _drawPath(canvas, [[98, 82], [108, 72], [112, 65], [106, 72], [98, 78]], s, fill_(AppColors.parrotGreenLight));
      _drawPath(canvas, [[96, 88], [110, 80], [115, 72], [108, 80], [98, 84]], s, fill_(AppColors.parrotGreen));
    }
  }

  void _drawFeather(Canvas canvas, double cx, double cy, double angle, double s, Color color) {
    canvas.save();
    canvas.translate(cx * s, cy * s);
    canvas.rotate(angle * 3.14159 / 180);
    canvas.drawOval(
      Rect.fromCenter(center: Offset.zero, width: 8 * s, height: 20 * s),
      Paint()..color = color..style = PaintingStyle.fill,
    );
    canvas.restore();
  }

  void _drawFoot(Canvas canvas, double x, double y, double s) {
    final paint = Paint()
      ..color = AppColors.parrotOrange
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2 * s
      ..strokeCap = StrokeCap.round;

    canvas.drawLine(Offset(x * s, y * s), Offset((x - 4) * s, (y + 10) * s), paint);
    canvas.drawLine(Offset(x * s, y * s), Offset(x * s, (y + 12) * s), paint);
    canvas.drawLine(Offset(x * s, y * s), Offset((x + 5) * s, (y + 10) * s), paint);
  }

  void _drawPath(Canvas canvas, List<List<num>> points, double s, Paint paint) {
    if (points.length < 3) return;
    final path = Path()..moveTo(points[0][0] * s, points[0][1] * s);
    for (var i = 1; i < points.length; i++) {
      path.lineTo(points[i][0] * s, points[i][1] * s);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ParrotPainter old) => old.mood != mood;
}
