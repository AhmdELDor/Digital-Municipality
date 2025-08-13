import 'package:flutter/material.dart';

class DottedLinePainter extends CustomPainter {
  final Color color;
  final double dashLength;
  final double dashGap;
  final double thickness;

  DottedLinePainter({
    required this.color,
    this.dashLength = 4.0,
    this.dashGap = 4.0,
    this.thickness = 2.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke;

    double startY = 0;
    while (startY < size.height) {
      double endY = (startY + dashLength).clamp(0.0, size.height);
      canvas.drawLine(
        Offset(size.width / 2.0, startY),
        Offset(size.width / 2.0, endY),
        paint,
      );
      startY += dashLength + dashGap;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
