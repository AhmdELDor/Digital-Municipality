import 'package:flutter/material.dart';
import '/presentation/common_widgets/widgets/text.dart';

class DotsIndicatorWithCount extends StatelessWidget {
  final int selectedIndex;
  final int itemCount;
  final Color? color;
  final Color? unselectedColor;
  final double _selectedHeight;
  final double _height;
  final double _selectedWidth;
  final double _width;
  final double gap;

  const DotsIndicatorWithCount({
    super.key,
    required this.itemCount,
    required this.selectedIndex,
    double? selectedHeight,
    double? height,
    double? selectedWidth,
    double? width,
    this.color,
    this.unselectedColor,
    this.gap = 4,
  })  : assert(itemCount > 0),
        assert(selectedIndex >= 0 && selectedIndex < itemCount),
        assert(gap >= 0),
        assert(selectedWidth == null || selectedWidth > 0),
        assert(width == null || width > 0),
        assert(selectedHeight == null || selectedHeight > 0),
        assert(height == null || height > 0),
        _selectedHeight = selectedHeight ?? height ?? 4,
        _height = height ?? selectedHeight ?? 4,
        _selectedWidth = selectedWidth ?? width ?? 12,
        _width = width ?? 6;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selectedColor = color ?? colorScheme.primary;
    final unselectedColor = this.unselectedColor ?? colorScheme.surface;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(
        itemCount,
        (index) {
          bool isSelected = selectedIndex == index;
          return AnimatedContainer(
            curve: Curves.ease,
            width: isSelected ? _selectedWidth : _width,
            height: isSelected ? _selectedHeight : _height,
            duration: const Duration(milliseconds: 500),
            margin:
                EdgeInsets.symmetric(horizontal: isSelected ? gap : gap / 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: isSelected ? selectedColor : unselectedColor,
            ),
            child: AnimatedCrossFade(
              duration: const Duration(milliseconds: 500),
              crossFadeState: isSelected
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              firstChild: Center(
                child: CommonText.light("${selectedIndex + 1}/$itemCount",
                    color: colorScheme.onPrimary,
                    size: 10,
                    textAlign: TextAlign.center,
                    height: 1.0),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
