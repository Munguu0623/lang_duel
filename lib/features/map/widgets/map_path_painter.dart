import 'package:flutter/material.dart';
import 'package:voice_duel/features/map/widgets/map_decorations.dart';

/// Paints the curvy path connecting stage nodes on the level map.
///
/// Draws three layers per segment:
/// 1. Shadow path (dark, offset)
/// 2. Main path (green if completed, dashed white if locked)
/// 3. Glow highlight on completed paths
class MapPathPainter extends CustomPainter {
  const MapPathPainter({
    required this.stageCount,
    required this.currentStage,
    required this.containerWidth,
  });

  final int stageCount;
  final int currentStage;
  final double containerWidth;

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < stageCount - 1; i++) {
      final x1 = StagePositions.xFraction(i) * containerWidth;
      final x2 = StagePositions.xFraction(i + 1) * containerWidth;
      final y1 = i * StagePositions.nodeSpacing + 55;
      final y2 = (i + 1) * StagePositions.nodeSpacing + 55;
      final mx = (x1 + x2) / 2 + (x2 > x1 ? 15 : -15);
      final my = (y1 + y2) / 2;
      final done = (i + 1) < currentStage;

      final path = Path()
        ..moveTo(x1, y1)
        ..quadraticBezierTo(mx, my, x2, y2);

      // 1) Shadow
      final shadowPath = Path()
        ..moveTo(x1, y1 + 3)
        ..quadraticBezierTo(mx, my + 3, x2, y2 + 3);
      canvas.drawPath(
        shadowPath,
        Paint()
          ..color = Colors.black.withOpacity(0.1)
          ..strokeWidth = done ? 7 : 5
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );

      // 2) Main path
      final mainPaint = Paint()
        ..color = done
            ? const Color(0xFF00B894)
            : Colors.white.withOpacity(0.35)
        ..strokeWidth = done ? 6 : 4
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round;

      if (!done) {
        _drawDashedPath(canvas, path, mainPaint, 10, 8);
      } else {
        canvas.drawPath(path, mainPaint);
        // 3) Glow line on top
        canvas.drawPath(
          path,
          Paint()
            ..color = const Color(0xFF55EFC4).withOpacity(0.5)
            ..strokeWidth = 2
            ..style = PaintingStyle.stroke
            ..strokeCap = StrokeCap.round,
        );
      }
    }
  }

  /// Draws a [path] with dashes of [dashLen] and gaps of [gapLen].
  void _drawDashedPath(
    Canvas canvas,
    Path path,
    Paint paint,
    double dashLen,
    double gapLen,
  ) {
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashLen).clamp(0.0, metric.length);
        final segment = metric.extractPath(distance, end);
        canvas.drawPath(segment, paint);
        distance += dashLen + gapLen;
      }
    }
  }

  @override
  bool shouldRepaint(covariant MapPathPainter old) =>
      old.currentStage != currentStage;
}
