import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../app/theme_controller.dart';
import '../widgets/text.dart';

Widget authTitleHeader(String title) {
  return Align(
    alignment: Alignment.center,
    child: CommonText.regular(
      title,
      size: 20,
      height: 1.0,
      letterSpacing: 0.0,
      textAlign: TextAlign.center,
    ),
  );
}

Widget authSubTitleHeader(String subTitle) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Align(
    alignment: Alignment.center,
    child: CommonText.regular(
      subTitle,
      size: 16,
      height: 1.5,
      letterSpacing: 0.0,
      textAlign: TextAlign.center,
      color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.bodyTextColor,
    ),
  );
}

Widget authHeader(String header) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.medium(
          header,
          size: 15,
          height: 1.0,
          letterSpacing: 0.0,
          textAlign: TextAlign.start,
        ),
        Gap(2),
        CommonText.medium(
          "*",
          size: 11,
          height: 1.0,
          letterSpacing: 0.0,
          textAlign: TextAlign.start,
          color: AppColors.error500,
        ),
      ],
    ),
  );
}
Widget commonHeader(String header) {
  return CommonText.medium(
    header,
    size: 15,
    height: 1.0,
    letterSpacing: 0.0,
    textAlign: TextAlign.start,
  );
}

Widget commonAuthBottomText(String leading,trailing,void Function()? onTap) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CommonText.medium(
        leading,
        size: 14,
        height: 1.0,
        letterSpacing: 0.0,
        textAlign: TextAlign.start,

      ),
      Gap(3),
      InkWell(
        onTap: onTap,
        child: CommonText.semiBold(
          trailing,
          size: 14,
          height: 1.0,
          letterSpacing: 0.0,
          textAlign: TextAlign.start,
          color: AppColors.error500,
        ),
      ),
    ],
  );
}

Widget dividerWithText(){
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return    Row(
    children: [
      Expanded(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient:
            isDarkMode? AppCommonGradient.dividerDarkOneGradient: AppCommonGradient.dividerOneGradient,
          ),
        ),
      ),
      Gap(5),
      CommonText.medium(
        SignInStrings.rememberMe,
        size: 17,
        height: 1.0,
        letterSpacing: 0.0,
        textAlign: TextAlign.center,
        color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.bodyTextColor,
      ),
      Gap(5),
      Expanded(
        child: Container(
          height: 1,
          decoration: BoxDecoration(
            gradient: isDarkMode?AppCommonGradient.dividerDarkTwoGradient:
            AppCommonGradient.dividerTwoGradient,
          ),
        ),
      ),
    ],
  );
}
