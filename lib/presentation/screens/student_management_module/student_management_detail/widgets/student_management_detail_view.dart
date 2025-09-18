import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/widgets/common_cache_image.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../controller/student_management_detail_controller.dart';
import '../model/payment_history_model.dart';

tabView(String image, name, int count, bool isSelected) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SvgImageFromAsset(
        image,
        height: 20,
        width: 20,
        colorFilter: ColorFilter.mode(
          isSelected
              ? AppColors.primary500
              : isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),

      Gap(5),
      CommonText.regular(
        '$name ($count)',
        size: 15,
        color: isSelected
            ? AppColors.primary500
            : (isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor),
      ),
    ],
  );
}

Widget buildCourseList(List<CourseModel> courses, BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  var tabletView = ResponsiveView.isTablet(context);
  var smallDesktop = ResponsiveView.isSmallDesktop(context);
  return SingleChildScrollView(
    child: ResponsiveGridRow(
      children: List.generate(courses.length, (index) {
        final course = courses[index];
        return ResponsiveGridCol(
          xs: 12,
          lg: 6,
           // md: 12,
           xl: 6,
          // sm: 12,
          child: Container(
            decoration: commonCardDecoration(12),
            margin: EdgeInsetsGeometry.only(right: 15, bottom: 15),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(9),
                  child: commonCacheImage(
                    course.image,
                    ImagePlaceHolder.imagePlaceHolderDark,
                    height: 155,
                    width: 155,
                    //fit: BoxFit.fill
                  ),
                ),
                Gap(15),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(mobileView ? 7 : 10),
                      CommonText.medium(
                        course.name,
                        size: mobileView ? 15 : 18,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(mobileView ? 7 : 10),
                      CommonText.regular(
                        course.description,
                        size: mobileView ? 13 : 16,
                        color: isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Gap(mobileView ? 7 : 10),

                      Row(
                        children: [
                          CommonText.semiBold(
                            '\$${course.courseFees.toString()}',
                            size: 17,
                            color: AppColors.primary500,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Gap(12),
                          tabletView
                              ? SizedBox()
                              : smallDesktop
                              ? SizedBox()
                              : SvgImageFromAsset(AppCommonIcon.starIcon),
                          Gap(7),
                          Expanded(
                            child: CommonText.semiBold(
                              course.rate.toString(),
                              size: mobileView ? 16 : 18,
                              color: AppColors.secondary500,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          tabletView
                              ? SizedBox()
                              : smallDesktop
                              ? SizedBox()
                              : mobileView
                              ? SizedBox()
                              : Container(
                                  //height: 26,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: course.status == "Completed"
                                        ? AppColors.success500
                                        : AppColors.secondary500,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Center(
                                    child: CommonText.medium(
                                      course.status,
                                      size: 14,
                                      color: AppColors.white,
                                    ),
                                  ),
                                ),
                        ],
                      ),
                      Gap(mobileView ? 7 : 0),
                      mobileView
                          ? Container(
                              //height: 26,
                              width: 72,
                              padding: EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: course.status == "Completed"
                                    ? AppColors.success500
                                    : AppColors.secondary500,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: CommonText.medium(
                                  course.status,
                                  size: mobileView ? 12 : 14,
                                  color: AppColors.white,
                                ),
                              ),
                            )
                          : SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    ),
  );
}

Widget commonDetailText(String title, subtitle, BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 12),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CommonText.regular(
            title,
            size: 16,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Expanded(
          child: CommonText.regular(
            subtitle,
            size: 16,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    ),
  );
}

Widget commonPointsView(String image, title, number, bool mobileView) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 12),
    child: Container(
      padding: EdgeInsets.symmetric(
        horizontal: 15,
        vertical: mobileView ? 15 : 20,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: isDarkMode
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                transform: GradientRotation(
                  260.86 * (3.1416 / 180),
                ), // degrees → radians
                colors: [
                  Color(0xFF000000), // #000000
                  Color(0xFF261600), // #261600
                ],
                stops: [-0.0299, 1.5273], // match -2.99% and 152.73%
              )
            : LinearGradient(
                begin: Alignment.topLeft, // adjust based on your angle
                end: Alignment.bottomRight, // adjust based on your angle
                colors: [
                  Color(0xFFFAFCFF), // #FAFCFF
                  Color(0xFFFFF9F0), // #FFF9F0
                ],
                stops: [-0.0303, 0.9915], // match your -3.03% and 99.15%
                transform: GradientRotation(
                  259.51 * 3.1415926535 / 180,
                ), // rotate to match angle
              ),
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1.5,
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SvgImageFromAsset(image),
                Gap(mobileView ? 15 : 20),
                Expanded(
                  child: CommonText.semiBold(
                    '#$number',
                    size: mobileView ? 18 : 22,
                    color: AppColors.orangeColor,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            Gap(20),
            CommonText.medium(
              title,
              size: mobileView ? 14 : 15,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ),
  );
}

Widget commonStatisticsView(String title, subtitle, bool mobileView) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Padding(
    padding: EdgeInsets.symmetric(horizontal: mobileView ? 0 : 12),
    child: Container(
      //height: mobileView?117:null,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(9),
        gradient: isDarkMode
            ? LinearGradient(
                colors: [
                  Color(0xFF000000), // black
                  Color(0xFF28040F), // dark maroon
                ],
                stops: [0.2794, 1.0], // 27.94% → 0.2794 | clamp 147.31% to 1.0
                transform: GradientRotation(
                  269.63 * 3.1416 / 180,
                ), // convert deg → rad
              )
            : LinearGradient(
                colors: [
                  Color(0xFFF8FBFF), // #F8FBFF
                  Color(0xFFFFFAFC), // #FFFAFC
                ],
                // stops: [
                //   0.1051,
                //   1.0813,
                // ], // 10.51% and 108.13% converted to 0–1 range
                transform: GradientRotation(
                  265.14 * 3.1415926535 / 180,
                ), // rotate 265.14° -> radians
              ),
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
      ),
      child:mobileView?Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CommonText.regular(title, size: 14),
          Gap(7),
          CommonText.semiBold(
            subtitle,
            size: 20,
            color: AppColors.darkPinkColor,
          ),
        ],
      ): Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: CommonText.regular(title, size: 16)),
          CommonText.semiBold(
            subtitle,
            size: 24,
            color: AppColors.darkPinkColor,
          ),
        ],
      ),
    ),
  );
}

Widget paymentView(PaymentHistoryModel data, bool mobileView,bool showMenu) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Container(
    decoration: commonCardDecoration(12),
    margin: EdgeInsetsGeometry.only(right: 20, bottom: 15),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: commonCacheImage(
                  data.courseImage,
                  ImagePlaceHolder.imagePlaceHolderDark,
                  height: 72,
                  width: 72,
                  //fit: BoxFit.fill
                ),
              ),
              Gap(15),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CommonText.medium(
                      data.courseName,
                      size: mobileView ? 14 : 15,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Gap(7),
                    CommonText.semiBold(
                      '\$${data.courseFees.toString()}',
                      size: mobileView ? 16 : 20,
                      color: AppColors.primary500,
                    ),
                  ],
                ),
              ),
              showMenu==true? menuButton():SizedBox()

            ],
          ),
        ),
        CommonDivider(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.regular(
                    StudentManagementDetailStrings.paymentDate,
                    size: 15,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                  CommonText.regular(
                    StudentManagementDetailStrings.paymentDate,
                    size: 15,
                  ),
                ],
              ),
              Gap(12),
              CommonDivider(),
              Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.regular(
                    StudentManagementDetailStrings.coinsUsed,
                    size: 15,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                  CommonText.regular(
                    StudentManagementDetailStrings.coinsUsed,
                    size: 15,
                  ),
                ],
              ),
              Gap(12),
              CommonDivider(),
              Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.regular(
                    StudentManagementDetailStrings.paymentMethod,
                    size: 15,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                  CommonText.regular(
                    StudentManagementDetailStrings.paymentMethod,
                    size: 15,
                  ),
                ],
              ),
              Gap(12),
              CommonDivider(),
              Gap(12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.regular(
                    StudentManagementDetailStrings.status,
                    size: 15,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                  CommonText.regular(
                    data.status,
                    size: 15,
                    color: data.status == 'Cancel'
                        ? AppColors.error600
                        : AppColors.success600,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}
menuButton() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return PopupMenuButton(
    color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(9),
      side: BorderSide(
        color: isDarkMode
            ? AppColors.grey100Color
            : AppColors.lightBorderColor,
        width: 2,
      ),
    ),
    child: commonPopTextView(AppCommonIcon.moreIcon),
    position: PopupMenuPosition.under,
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: commonDeviceView(
            AppCommonIcon.editIcon,
            CourseManagementStrings.edit,
            null,
          ),
        ),
      ),

      PopupMenuItem(
        value: 2,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: commonDeviceView(
            AppCommonIcon.deleteIcon,
            ApprovalsStrings.delete,
            null,
          ),
        ),
      ),
    ],
  );
}
Widget paymentListView(bool mobileView,bool showMenu) {
  StudentManagementDetailController controller = Get.put(
    StudentManagementDetailController(),
  );
  return SingleChildScrollView(
    child: ResponsiveGridRow(
      children: List.generate(controller.data.value.paymentHistoryList.length, (
        index,
      ) {
        final data = controller.data.value.paymentHistoryList[index];
        return ResponsiveGridCol(lg: 4, child: paymentView(data, mobileView,showMenu));
      }),
    ),
  );
}
