import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../app/theme_controller.dart';

Widget customTab(String label, String image, {required bool isSelected}) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(
          image,
          height: 20,
          width: 20,
          colorFilter: ColorFilter.mode(
            isSelected
                ? AppColors.primary500
                : isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            BlendMode.srcIn
          ),
        ),
        Gap(8),
        CommonText.semiBold(
          label,
          size: 16,
          color: isSelected ? AppColors.primary500 : AppColors.bodyTextColor,
          fontWeight: isSelected ? FontWeight.w500 : FontWeight.w400,
        ),
      ],
    ),
  );
}
