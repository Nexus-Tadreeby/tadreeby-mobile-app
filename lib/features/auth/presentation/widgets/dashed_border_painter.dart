import 'package:flutter/material.dart';

class DashedBorderPainter extends CustomPainter {
  

  final Color color;
  final double strokeWidth;
  final double dashLength;
  final double dashSpace;
  final double radius;

  DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.5,
    this.dashLength = 8,
    this.dashSpace = 6,
    this.radius = 14,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(radius),
      ));

    _drawDashedPath(canvas, path, paint);
  }

  void _drawDashedPath(Canvas canvas, Path path, Paint paint) {
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0;
      bool draw = true;
      while (distance < metric.length) {
        final length = draw ? dashLength : dashSpace;
        if (distance + length > metric.length) {
          break;
        }
        final segment = metric.extractPath(distance, distance + length);
        canvas.drawPath(segment, paint);
        distance += length;
        draw = !draw;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate){
    return oldDelegate.color != color || 
           oldDelegate.strokeWidth != strokeWidth ||
           oldDelegate.radius != radius ||
           oldDelegate.dashLength != dashLength ||
           oldDelegate.dashSpace != dashSpace;
  }
}