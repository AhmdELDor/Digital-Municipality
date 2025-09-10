import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';


class CommonCircleAddButton extends StatelessWidget {
  final void Function()? onTap;
  const CommonCircleAddButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return InkWell(
      onTap: onTap,
      child: Container(
        height: mobileView?32:36,
        width:  mobileView?32:36,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.mainDarkBgColor
              : AppColors.lightBgColor,
          borderRadius: BorderRadius.circular(7),
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
        ),
        child: Center(
          child: SvgImageFromAsset(
            AppCommonIcon.circleAddIcon,
            colorFilter: ColorFilter.mode(
              isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}

