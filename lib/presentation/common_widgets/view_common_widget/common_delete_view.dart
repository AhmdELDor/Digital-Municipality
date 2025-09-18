import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';
class CommonDeleteView extends StatelessWidget {
  final void Function()? onTap;
  const CommonDeleteView({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    //var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return  InkWell(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 30,
        decoration: BoxDecoration(
          color: isDarkMode
              ? AppColors.error500
              : AppColors.error100,
          borderRadius: BorderRadius.circular(
            7,
          ),
        ),
        child: Center(
          child: SvgImageFromAsset(
            AppCommonIcon.quizDeleteIcon,
            height: 20,
            width: 20,
            colorFilter: ColorFilter.mode(
              isDarkMode
                  ? AppColors.white
                  : AppColors.error500,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
