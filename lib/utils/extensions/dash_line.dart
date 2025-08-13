import 'package:flutter/material.dart';

class DashLine extends StatelessWidget {
  final double height;
  final Color color;
  final Axis direction;

  const DashLine({
    super.key,
    this.height = 1,
    this.color = Colors.black,
    this.direction = Axis.horizontal,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 3.5;
        final dashHeight = height;
        final dashCount = (boxWidth / (0.80 * dashWidth)).floor();
        return Flex(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          direction: direction,
          children: List.generate(dashCount, (_) {
            return SizedBox(
              width: direction == Axis.vertical ? dashHeight : dashWidth,
              height: direction == Axis.vertical ? dashWidth : dashHeight,
              child: DecoratedBox(
                decoration: BoxDecoration(color: color),
              ),
            );
          }),
        );
      },
    );
  }
}
