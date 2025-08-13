import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../app/theme_controller.dart';
import 'text.dart';

Future<void> showConfirmationDialog({
  required String title,
  required String description,
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String cancelText = AppCommonStrings.btnCancel,
  String confirmText = AppCommonStrings.btnRemove,
  Color confirmColor = AppColors.error500,
  bool isDestructive = true,
}) {
  return showDialog(
    context: Get.context!,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bold(
                title,
                size: 20,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 15),
              CommonText.medium(
                description,
                size: 14,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                color: Get.find<ThemeController>().isDarkMode ? AppColors.headingsLightColor :AppColors.headingsColor,
              ),
              const SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {
                      Get.back();
                      onCancel?.call();
                    },
                    child: CommonText.extraBold(
                      cancelText,
                      size: 16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: Get.find<ThemeController>().isDarkMode ? AppColors.headingsLightColor :AppColors.headingsColor,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Get.back();
                      onConfirm();
                    },
                    child: CommonText.extraBold(
                      confirmText,
                      size: 16,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      color: confirmColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
