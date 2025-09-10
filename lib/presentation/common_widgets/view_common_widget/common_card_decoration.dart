import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/theme_controller.dart';
import '../widgets/text.dart';

Widget authBackgroundImageView(BuildContext context) {
  bool isMobile = ResponsiveView.isMobile(context);

  return isMobile
      ? SizedBox()
      : Padding(
          padding: const EdgeInsets.only(top: 40, left: 40, bottom: 40),
          child: Container(
            height: context.height,
            constraints: BoxConstraints(
              maxWidth: 700
            ),
            // width: isTablet
            //     ? 0
            //     : isSmallDesktop
            //     ? 500
            //     : 700,
            padding: EdgeInsets.symmetric(horizontal: 70, vertical: 70),
            decoration: BoxDecoration(
              //color: Colors.yellow,
              borderRadius: BorderRadius.circular(50),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(CommonImageAssets.authBg),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.semiBold(
                    SignInStrings.simplifyYourManagement,
                    size: 40,
                    color: AppColors.white,
                    textAlign: TextAlign.start,
                  ),
                  Gap(20),
                  CommonText.regular(
                    SignInStrings.simplifyYourManagementDes,
                    size: 16,
                    color: AppColors.white,
                    textAlign: TextAlign.start,
                  ),
                ],
              ),
            ),
          ),
        );
}

Widget authSpaceView(BuildContext context){
  bool isMobile = ResponsiveView.isMobile(context);
  return  isMobile ? SizedBox() : Expanded(flex: 1, child: Container());

}
BoxDecoration commonCardDecoration(double borderRadius) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return BoxDecoration(
    color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
    borderRadius: BorderRadius.circular(borderRadius),
    border: Border.all(
      color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
      width: 1.5,
    ),
  );
}

BoxDecoration commonDetailCardDecoration() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return BoxDecoration(
    borderRadius: BorderRadius.circular(4),
    color: isDarkMode?AppColors.greyDarkColor:AppColors.lightBorderColor.withValues(alpha: 0.40),
    border: Border.all(color: isDarkMode?AppColors.grey100Color:AppColors.lightBorderColor, width: 1),
  );
}

BoxDecoration commonGradiantDecoration() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return BoxDecoration(
    color: isDarkMode ? AppColors.mainDarkBgColor : null,
    gradient: isDarkMode ? null : AppCommonGradient.backgroundGradient,
  );
}
InputDecoration dropDownDecoration() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return InputDecoration(
    border: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode?AppColors.grey100Color: AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    enabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color:isDarkMode?AppColors.grey100Color: AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    disabledBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode?AppColors.grey100Color: AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(
        color: isDarkMode?AppColors.grey100Color: AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(7),
    ),
  );
}