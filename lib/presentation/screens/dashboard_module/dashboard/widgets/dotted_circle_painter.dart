import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../../../core/constants/app_colors.dart';

class DottedCirclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double radius = size.width / 2;
    final Paint dotPaint = Paint()
      ..color = AppColors.greyColor.withValues(alpha: 0.50)
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1;

    final int dotsCount = 80;
    for (int i = 0; i < dotsCount; i++) {
      double angle = (2 * 3.1415926 * i) / dotsCount;
      final double x = radius + radius * 0.95 * cos(angle);
      final double y = radius + radius * 0.95 * sin(angle);
      canvas.drawPoints(PointMode.points, [Offset(x, y)], dotPaint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}