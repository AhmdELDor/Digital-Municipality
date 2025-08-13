import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';

Future<void> commonDialogBox({required BuildContext context, required Widget child}) async {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        backgroundColor: isDarkMode
            ? AppColors.headingsColor
            : AppColors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child:child,
          ),
        ),
      );
    },
  );
}