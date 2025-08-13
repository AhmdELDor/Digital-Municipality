import 'package:flutter/material.dart';

class DashedLineDivider extends StatelessWidget {
  final double height;
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  const DashedLineDivider({
    super.key,
    this.height = 1,
    this.dashWidth = 5,
    this.dashSpacing = 3,
    this.color = Colors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(double.infinity, height),
      painter: _DashedLinePainter(
        dashWidth: dashWidth,
        dashSpacing: dashSpacing,
        color: color,
      ),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  final double dashWidth;
  final double dashSpacing;
  final Color color;

  _DashedLinePainter({
    required this.dashWidth,
    required this.dashSpacing,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = size.height;

    double startX = 0;
    final maxX = size.width;

    while (startX < maxX) {
      canvas.drawLine(
        Offset(startX, 0),
        Offset(startX + dashWidth, 0),
        paint,
      );
      startX += dashWidth + dashSpacing;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
