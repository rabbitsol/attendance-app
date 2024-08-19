import 'package:flutter/material.dart';

class ScanningPainter extends CustomPainter {
  final double value;

  ScanningPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;

    final centerX = size.width / 2;
    final centerY = size.height / 2;
    final radius = size.width / 2;

    final startAngle = -value * 3.14159265359;
    final sweepAngle = 2 * value * 3.14159265359;

    final rect =
        Rect.fromCircle(center: Offset(centerX, centerY), radius: radius);

    canvas.drawArc(rect, startAngle, sweepAngle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
