import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';

class CommonDivider extends StatelessWidget {
  final double height;
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  const CommonDivider({
    this.height = 1.5,
    this.thickness = 1.0,
    this.indent = 0.0,
    this.endIndent = 0.0,
    this.color,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Divider(
      height: height,
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? (isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor),
    );
  }
}
