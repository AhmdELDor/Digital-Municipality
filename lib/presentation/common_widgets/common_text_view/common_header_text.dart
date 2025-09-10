import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';

Widget commonHeaderText({required String title}){
  return CommonText.semiBold(title,size: 17,);
  
}

Widget commonLeadingTrailingView(String leading, trailing) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: CommonText.regular(
            leading,
            size: 15,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        CommonText.regular(trailing, size: 15),
      ],
    ),
  );
}