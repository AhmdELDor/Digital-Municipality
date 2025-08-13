import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';
import '../widgets/text.dart';

Widget commonEmptyView({
  required String image,
  required String title,
  required String subtitle,
}) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Column(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      SvgImageFromAsset(image),
      Gap(20),
      CommonText.semiBold(title),
      Gap(10),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CommonText.regular(
          subtitle,
          size: 15,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          textAlign: TextAlign.center,
        ),
      ),
    ],
  );
}
