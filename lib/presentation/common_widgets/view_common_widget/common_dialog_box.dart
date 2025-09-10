import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';

Future<void> commonDialogBox({
  required BuildContext context,
  required Widget child,
}) async {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        insetPadding: EdgeInsets.symmetric(horizontal: 15),
        backgroundColor: isDarkMode
            ? AppColors.mainDarkBgColor
            : AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
          ),
        ),
        child: SingleChildScrollView(child: child),
      );
    },
  );
}

Widget commonCloseIcon(BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return InkWell(
    onTap: () {
      Navigator.pop(context);
    },
    child: SvgImageFromAsset(
      AppCommonIcon.closeIcon,
      colorFilter: ColorFilter.mode(
        isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
        BlendMode.srcIn,
      ),
    ),
  );
}
