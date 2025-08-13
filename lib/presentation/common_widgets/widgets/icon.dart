import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import 'image.dart';

class BackIcon extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackIcon({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {

    void goBackOrCloseApp() {
      if (Get.isSnackbarOpen) {
       // Get.back(); // Close snackbar if open
        Navigator.pop(context);
      } else if (Navigator.canPop(Get.context!)) {
        Navigator.pop(context);
      } else {
        SystemNavigator.pop();
      }
    }

    return ActionIcon(
      visualDensity: VisualDensity.comfortable,
      onPressed: onPressed ??goBackOrCloseApp /*Navigator.of(context).maybePop*/,
      tooltip: MaterialLocalizations.of(context).backButtonTooltip,

      icon: SvgImageFromAsset.square(
        size: 25,
        AppCommonIcon.backIcon,
        colorFilter: ColorFilter.mode(
          Get.find<ThemeController>().isDarkMode
              ? AppColors.headingsLightColor
              : AppColors.headingsColor,
          BlendMode.srcIn,
        ),
        fit: BoxFit.scaleDown,
      ),
    );

  }
}

class ActionIcon extends StatelessWidget {
  final Widget icon;
  final VoidCallback? onPressed;
  final VisualDensity? visualDensity;
  final String? tooltip;
  final double? iconSize;

  const ActionIcon({
    super.key,
    required this.onPressed,
    required this.icon,
    this.visualDensity = VisualDensity.compact,
    this.tooltip,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(),
      child: IconButton(
        icon: icon,
        onPressed: onPressed,
        visualDensity: visualDensity,
        tooltip: tooltip,
        iconSize: iconSize,
      ),
    );
  }
}
