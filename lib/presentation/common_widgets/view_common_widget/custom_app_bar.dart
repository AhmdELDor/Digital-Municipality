import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_strings.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/app_route.dart';
import '../../app/theme_controller.dart';
import '../input_field/common_search_field.dart';
import '../widgets/button.dart';
import '../widgets/common_divider.dart';
import '../widgets/icon.dart';
import '../widgets/text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextEditingController searchController;
  final void Function()? onSearchTap;
  final FocusNode? searchFocusNode;
  final void Function() drawerOnTap;
  final bool? showBackIcon;
  CustomAppBar({
    super.key,
    required this.searchController,
    this.onSearchTap,
    this.searchFocusNode,
    required this.drawerOnTap, this.showBackIcon,
  });
  final bool isDarkMode = Get.find<ThemeController>().isDarkMode;

  @override
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      automaticallyImplyLeading: false,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: isDarkMode
            ? Brightness.light
            : Brightness.dark,
        statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
      ),
      bottom: PreferredSize(
        preferredSize: preferredSize,
        child: mobileView
            ? deviceAppBar(onTap: drawerOnTap, context: context)
            : deskTopAppBar(context),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(77);

  deskTopAppBar(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: CommonSearchField(
                  controller: searchController,
                  hintText: DashboardViewStrings.searchAnything,
                  focusNode: searchFocusNode,
                  onSearchTap: onSearchTap,
                ),
              ),
              Gap(16),
              addCourseButton(context),
              Gap(16),
              Container(
                width: 1,
                height: 40,
                color: isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.lightBorderColor,
              ),
              Gap(16),
              darkModeButton(context),
              Gap(16),
              notificationView(context),
              Gap(16),
              InkWell(
                onTap: () {
                  context.pop(AppRouteName.profileView);
                },
                child: SvgImageFromAsset(
                  CommonImageAssets.userProfileImg,
                  height: 40,
                  width: 40,
                ),
              ),
              Gap(8),
              userDataView(),
              Gap(8),
              SvgImageFromAsset(
                AppCommonIcon.downArrowIcon,
                height: 10,
                width: 10,
                colorFilter: ColorFilter.mode(
                  isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
        ),
        CommonDivider(),
        Gap(5),
      ],
    );
  }

  deviceAppBar({
    required void Function() onTap,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.white,
        boxShadow: [
          BoxShadow(
            offset: Offset(0, -2),
            color: AppColors.appBarShadowColor.withValues(alpha: 0.08),
            blurRadius: 16,
            spreadRadius: -3,
          ),
        ],
      ),
      child: Row(
        children: [
          showBackIcon==true?BackIcon(
            onPressed:() {
             Navigator.pop(context);
            },
          ):
          InkWell(
            onTap: onTap,
            child: SvgImageFromAsset(
              AppCommonIcon.drawerIcon,
              colorFilter: ColorFilter.mode(
                isDarkMode ? AppColors.white : AppColors.headingsColor,
                BlendMode.srcIn,
              ),
              height: 24,
              width: 24,
            ),
          ),
          Spacer(),
          addCourseButton(context),
          Gap(10),
          darkModeButton(context),
          Gap(10),
          notificationView(context),
          Gap(10),
          InkWell(
            onTap: () {
              context.push(AppRouteName.profileView);
            },
            child: SvgImageFromAsset(
              CommonImageAssets.userProfileImg,
              height: 32,
              width: 32,
            ),
          ),
        ],
      ),
    );
  }

  addCourseButton(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return SizedBox(
      width: mobileView ? 32 : 125,
      child: PrimaryButton(
        height: mobileView ? 32 : 40,
        onPressed: () {
          context.push(AppRouteName.addCourseView,);
        },
        label: mobileView ? '' : DashboardViewStrings.newCourse,
        prefixIcon: Padding(
          padding:  EdgeInsets.only(left: mobileView?5:0),
          child: SvgImageFromAsset(AppCommonIcon.circleAddIcon),
        ),
        textSize: 14,
        textWeight: FontWeight.w600,
      ),
    );
  }

  darkModeButton(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return SizedBox(
      width: mobileView ? 32 : 125,
      child: PrimaryButton(
        height: mobileView ? 32 : 40,
        backgroundColor: Colors.transparent,
        borderSide: BorderSide(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1.5,
        ),
        onPressed: () {
          //isDarkMode.value = value;
          Get.find<ThemeController>().toggleTheme();
          Get.forceAppUpdate();
        },
        label: mobileView
            ? ''
            : isDarkMode
            ? DashboardViewStrings.lightMode
            : DashboardViewStrings.darkMode,
        prefixIcon: Padding(
          padding:  EdgeInsets.only(left: mobileView?5:0),
          child: SvgImageFromAsset(
            isDarkMode ? AppCommonIcon.sunIcon : AppCommonIcon.moonIcon,
          ),
        ),

        textColor: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
        textSize: 14,
        textWeight: FontWeight.w500,
      ),
    );
  }

  notificationView(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return InkWell(
      onTap: () {
        context.push(AppRouteName.notificationView);
      },
      child: Container(
        height: mobileView ? 32 : 40,
        width: mobileView ? 61 : 40,
        decoration: BoxDecoration(
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(mobileView ? 6 : 40),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgImageFromAsset(
              AppCommonIcon.notificationIcon,
              colorFilter: ColorFilter.mode(
                isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                BlendMode.srcIn,
              ),
            ),
            Gap(mobileView ? 5 : 0),
            mobileView
                ? CommonText.semiBold('14', color: AppColors.error500, size: 14)
                : SizedBox(),
          ],
        ),
      ),
    );
  }

  userDataView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CommonText.medium(
          'Emily Parker',
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
        Gap(5),
        CommonText.medium(
          'Super Admin',
          size: 12,
          color: isDarkMode
              ? AppColors.greyTextDarkColor
              : AppColors.greyTextColor,
        ),
      ],
    );
  }
}
