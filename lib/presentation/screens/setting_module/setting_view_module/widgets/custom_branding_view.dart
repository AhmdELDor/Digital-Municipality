import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/button.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../controller/setting_view_controller.dart';
import 'add_language_view.dart';

class CustomBrandingView extends StatefulWidget {
  const CustomBrandingView({super.key});

  @override
  State<CustomBrandingView> createState() => _CustomBrandingViewState();
}

class _CustomBrandingViewState extends State<CustomBrandingView> {
  SettingViewController controller = Get.put(SettingViewController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: ResponsiveGridRow(
        children: [
          ResponsiveGridCol(
            lg: 6,
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: mobileView?deviceView(isDarkMode):desktopView(isDarkMode),
            ),
          ),
          ResponsiveGridCol(
            lg: 6,
            child: Container(
              margin: EdgeInsetsGeometry.only(left: mobileView?0:20,top: mobileView?20:0),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: mobileView?deviceLanguageView(isDarkMode):desktopLanguageView(isDarkMode)
            ),
          ),
        ],
      ),
    );
  }

  Widget desktopView(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: CommonText.regular(
            SettingViewStrings.platformColourPreference,
            size: 16,
          ),
        ),
        CommonDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.cardDarkBg2Color
                          : AppColors.primary50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgImageFromAsset(CommonImageAssets.appLogo),
                    ),
                  ),
                  Gap(12),
                  CommonText.semiBold(
                    SettingViewStrings.change,
                    size: 15,
                    color: AppColors.primary500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary500,
                  ),
                ],
              ),
              Gap(45),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CommonText.regular(
                      SettingViewStrings.platformName,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    Gap(7),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText.medium(SettingViewStrings.eduLift, size: 15),
                        Spacer(),
                        SvgImageFromAsset(
                          AppCommonIcon.editIcon,
                          colorFilter: ColorFilter.mode(
                            AppColors.primary500,
                            BlendMode.srcIn,
                          ),
                        ),
                      ],
                    ),

                    Gap(43),
                    Row(
                      children: [
                        colorView(
                          title: SettingViewStrings.primaryColor,
                          color: AppColors.primary500,
                          colorCode: '#4A90EB',
                        ),
                        Spacer(),
                        colorView(
                          title: SettingViewStrings.secondaryColor,
                          color: AppColors.secondary500,
                          colorCode: '#F98D07',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget deviceView(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.regular(
                SettingViewStrings.platformColourPreference,
                size: 14,
              ),
              SizedBox(
                width: 70,
                child: PrimaryButton(
                  height: 30,
                  onPressed: () {},
                  label: AppCommonStrings.btnUpdate,
                ),
              ),
            ],
          ),
        ),
        CommonDivider(),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 72,
                    width: 72,
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.cardDarkBg2Color
                          : AppColors.primary50,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: SvgImageFromAsset(CommonImageAssets.appLogo),
                    ),
                  ),

                  CommonText.semiBold(
                    SettingViewStrings.change,
                    size: 14,
                    color: AppColors.primary500,
                    decoration: TextDecoration.underline,
                    decorationColor: AppColors.primary500,
                  ),
                ],
              ),
              Gap(15),
              CommonDivider(), Gap(15),
              CommonText.regular(
                SettingViewStrings.platformName,
                size: 15,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
              Gap(7),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.medium(SettingViewStrings.eduLift, size: 15),
                  Spacer(),
                  SvgImageFromAsset(
                    AppCommonIcon.editIcon,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary500,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ), Gap(15),
              CommonDivider(),
              Gap(15),
              CommonText.regular(
                SettingViewStrings.primaryColor,
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color:  AppColors.primary500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Gap(15),
                  Expanded(child: CommonText.regular('#4A90EB', size: 16)),
                  Gap(15),
                  SvgImageFromAsset(
                    AppCommonIcon.editIcon,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary500,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
              Gap(15),
              CommonText.regular(
                SettingViewStrings.secondaryColor,
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(10),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 36,
                    width: 36,
                    decoration: BoxDecoration(
                      color:  AppColors.secondary500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                  Gap(15),
                  Expanded(child: CommonText.regular('#F98D07', size: 16)),
                  Gap(15),
                  SvgImageFromAsset(
                    AppCommonIcon.editIcon,
                    colorFilter: ColorFilter.mode(
                      AppColors.primary500,
                      BlendMode.srcIn,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),




      ],
    );
  }

  Widget colorView({
    required String title,
    required Color color,
    required String colorCode,
  }) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.regular(
            title,
            size: 16,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Gap(10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 36,
                  width: 36,
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                Gap(15),
                CommonText.regular(colorCode, size: 16),
                Gap(15),
                SvgImageFromAsset(
                  AppCommonIcon.editIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.primary500,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget desktopLanguageView(bool isDarkMode){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText.regular(
                  SettingViewStrings.languageThemePreference,
                  size: 16,
                ),
              ),
              SizedBox(
                width: 108,
                child: PrimaryButton(
                  height: 30,
                  textSize: 14,
                  textWeight: FontWeight.w500,
                  onPressed: () {
                    commonDialogBox(
                      context: context,
                      child: SizedBox(
                        width: 560,
                        child: AddLanguageView(),
                      ),
                    );
                  },
                  label: SettingViewStrings.addLanguage,
                ),
              ),
              Gap(12),
              SizedBox(
                width: 63,
                child: PrimaryButton(
                  height: 30,
                  textSize: 14,
                  textWeight: FontWeight.w500,
                  onPressed: () {},
                  label: SettingViewStrings.update,
                ),
              ),
            ],
          ),
        ),
        CommonDivider(),

        Padding(
          padding: const EdgeInsets.only(top: 15, right: 15, left: 15),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.regular(
                      SettingViewStrings.languagePreference,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                    Gap(12),
                    ListView.builder(
                      itemCount: controller.languageList.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 100,
                                child: CommonText.regular(
                                  controller.languageList[index],
                                  size: 16,
                                ),
                              ),
                              Gap(30),
                              SvgImageFromAsset(
                                AppCommonIcon.deleteIcon,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonText.regular(
                      SettingViewStrings.themePreference,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                                () => Checkbox(
                              value: controller.isLightMode.value,
                              onChanged: (value) {
                                controller.isLightMode.value = value!;
                              },
                              checkColor: AppColors.white,
                              activeColor: AppColors.primary500,
                            ),
                          ),
                          CommonText.regular(
                            SettingViewStrings.lightTheme,
                            size: 16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Gap(15),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Obx(
                                () => Checkbox(
                              value: controller.isDarkMode.value,
                              onChanged: (value) {
                                controller.isDarkMode.value = value!;
                                Get.find<ThemeController>().toggleTheme();
                                Get.forceAppUpdate();
                              },
                              checkColor: AppColors.white,
                              activeColor: AppColors.primary500,
                            ),
                          ),
                          CommonText.regular(
                            SettingViewStrings.darkTheme,
                            size: 16,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget deviceLanguageView(bool isDarkMode){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 12,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: CommonText.medium(
                  SettingViewStrings.languageThemePreference,
                  size: 14,
                ),
              ),
              CommonCircleAddButton(
                onTap: () {
                  commonDialogBox(
                    context: context,
                    child: SizedBox(
                      width: 560,
                      child: AddLanguageView(),
                    ),
                  );
                },
              ),

              Gap(12),
              SizedBox(
                width: 70,
                child: PrimaryButton(
                  height: 30,
                  textSize: 14,
                  textWeight: FontWeight.w500,
                  onPressed: () {},
                  label: SettingViewStrings.update,
                ),
              ),
            ],
          ),
        ),
        CommonDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CommonText.regular(
                SettingViewStrings.languagePreference,
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
              Gap(12),
              ListView.builder(
                itemCount: controller.languageList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CommonText.regular(
                          controller.languageList[index],
                          size: 16,
                        ),

                        SvgImageFromAsset(
                          AppCommonIcon.deleteIcon,
                        ),
                      ],
                    ),
                  );
                },
              ),
              Gap(30),
              CommonText.regular(
                SettingViewStrings.themePreference,
                size: 16,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                        () => Checkbox(
                      value: controller.isLightMode.value,
                      onChanged: (value) {
                        controller.isLightMode.value = value!;
                      },
                      checkColor: AppColors.white,
                      activeColor: AppColors.primary500,
                    ),
                  ),
                  CommonText.regular(
                    SettingViewStrings.lightTheme,
                    size: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              Gap(20),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Obx(
                        () => Checkbox(
                      value: controller.isDarkMode.value,
                      onChanged: (value) {
                         controller.isDarkMode.value = value!;
                        // Get.find<ThemeController>().toggleTheme();
                        // Get.forceAppUpdate();
                      },
                      checkColor: AppColors.white,
                      activeColor: AppColors.primary500,
                    ),
                  ),
                  CommonText.regular(
                    SettingViewStrings.darkTheme,
                    size: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ],
          ),
        ),


      ],
    );
  }

}
