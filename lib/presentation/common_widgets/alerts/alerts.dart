import 'package:get/get.dart';

import '../../app/theme_controller.dart';
import '/core/constants/app_colors.dart';

import '/core/themes/app_color_extension.dart';
import '/utils/extensions/context_extensions.dart';
import 'package:flutter/material.dart';

import '../widgets/alert_message.dart';
import '../widgets/modals.dart';

void showSuccessMessage({
  required BuildContext context,
  required String title,
  required String content,
  int? duration,
}) {
  final context = Get.context!;
  ScaffoldMessenger.of(context).showSnackBar(
    AlertMessage(
      title: title,
      description: content,
      backgroundColor: context.appColor.success,
      foregroundColor:
          Get.find<ThemeController>().isDarkMode
              ? AppColors.success500
              : AppColors.success400,
      duration: Duration(seconds: duration ?? 5),

    ),
  );
}

void showErrorMessage({
  required BuildContext context,
  required String title,
  required String content,
  int? duration,
}) {
  ScaffoldMessenger.of(context).showSnackBar(
    AlertMessage(
      title: title,
      description: content,
      backgroundColor: context.colorScheme.error,
      foregroundColor: Get.find<ThemeController>().isDarkMode
          ? AppColors.error500
          : AppColors.error400,
      duration: Duration(seconds: duration ?? 5),
    ),
  );
}

Future<void> showErrorSheet({
  required BuildContext context,
  required String title,
  required String content,
  required ModalButton button,
}) {
  return showGeneralDialog(
    context: context,
    routeSettings: const RouteSettings(name: "/error_dialog"),
    barrierDismissible: false,
    barrierLabel: "error_dialog",
    pageBuilder:
        (context, animation, secondaryAnimation) =>
            ErrorSheet(title: title, content: content, button: button),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder:
        (context, animation, secondaryAnimation, child) => SlideTransition(
          position: Tween(
            begin: const Offset(0, 1),
            end: const Offset(0, 0.0),
          ).animate(animation),
          child: child,
        ),
  );
}

Future<T?> showAppDialog<T>({
  required BuildContext context,
  required String title,
  required String content,
  Widget? icon,
  ModalButton? positiveButton,
  ModalButton? negativeButton,
  bool barrierDismissible = true,
}) {
  return showGeneralDialog<T>(
    context: context,
    routeSettings: const RouteSettings(name: "/app_dialog"),
    barrierDismissible: barrierDismissible,
    barrierLabel: "app_dialog",
    pageBuilder:
        (context, animation, secondaryAnimation) => SafeArea(
          child: AppDialog(
            title: title,
            content: content,
            icon: icon,
            positiveButton: positiveButton,
            negativeButton: negativeButton,
          ),
        ),
    transitionDuration: const Duration(milliseconds: 100),
    transitionBuilder:
        (context, animation, secondaryAnimation, child) =>
            FadeTransition(opacity: animation, child: child),
  );
}
