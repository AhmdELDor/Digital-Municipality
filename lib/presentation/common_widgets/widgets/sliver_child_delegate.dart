import 'dart:math' as math;

import 'package:flutter/material.dart';

class SliverChildSeparatedDelegate extends SliverChildBuilderDelegate {
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder separatorBuilder;

  SliverChildSeparatedDelegate({
    required this.itemCount,
    required this.itemBuilder,
    required this.separatorBuilder,
  }) : super(
          (context, initialIndex) {
            final int index = initialIndex ~/ 2;
            if (initialIndex.isEven) return itemBuilder(context, index);
            return separatorBuilder(context, index);
          },
          childCount: math.max(0, (itemCount * 2) - 1),
          semanticIndexCallback: (child, index) => index ~/ 2,
        );
}
