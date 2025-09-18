import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/theme_controller.dart';
import '../../screens/approvals_module/approvals_course_view/widgets/course_approvals_menu_button.dart';
import '../../screens/approvals_module/approvals_course_view/widgets/course_approvals_second_menu_button.dart';
import '../../screens/dashboard_module/dashboard/model/course_model.dart';

class CommonCourseView extends StatelessWidget {
  final CourseModel course;
  final bool? showRate;
  final bool? showSwitch;
  final bool? showMenuButton;
  final bool? differentView;
  final bool? showCheckBox;

  final void Function() viewCourseOnTap;
  final void Function() declinedOnTap;
  final void Function() deleteOnTap;
  final void Function() editViewCourseOnTap;
  final void Function()? deleteCourseOnTap;
  final void Function()? editCourseOnTap;
  const CommonCourseView({
    super.key,
    required this.course,
    this.showRate,
    this.showSwitch,
    this.showMenuButton,
    this.differentView,
    this.showCheckBox,
    required this.viewCourseOnTap,
    required this.declinedOnTap,
    required this.deleteOnTap,
    required this.editViewCourseOnTap,
     this.deleteCourseOnTap,
     this.editCourseOnTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    double spacing = 20;
    return Container(
      //decoration: commonCardDecoration(12),
      margin: EdgeInsetsGeometry.only(bottom: 15),
      child: differentView == true
          ? mobileView
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(6),
                              topRight: Radius.circular(6),
                            ),
                            child: commonCacheImage(
                              course.image,
                              ImagePlaceHolder.imagePlaceHolderDark,
                              height: 170,
                              width: double.infinity,
                              //fit: BoxFit.contain
                            ),
                          ),
                          Positioned(
                            top: 10,
                            right: 10,
                            child: showMenuButton == true
                                ? CourseApprovalsSecondMenuButton(
                                    course: course,
                                    editCourseOnTap: editCourseOnTap,
                                    viewCourseOnTap: editViewCourseOnTap,
                                    deleteCourseOnTap: deleteCourseOnTap,
                                  )
                                : CourseApprovalsMenuButton(
                                    course: course,
                                    viewCourseOnTap: viewCourseOnTap,
                                    declinedOnTap: declinedOnTap,
                                    deleteOnTap: deleteOnTap,
                                  ),
                          ),
                        ],
                      ),

                      //   Gap(12),
                      Container(
                        decoration: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.mainDarkBgColor
                              : AppColors.lightBgColor,
                          border: Border(
                            left: BorderSide(
                              color: isDarkMode
                                  ? AppColors.grey100Color
                                  : AppColors.lightBorderColor,
                              width: 1,
                            ),
                            bottom: BorderSide(
                              color: isDarkMode
                                  ? AppColors.grey100Color
                                  : AppColors.lightBorderColor,
                              width: 1,
                            ),
                            right: BorderSide(
                              color: isDarkMode
                                  ? AppColors.grey100Color
                                  : AppColors.lightBorderColor,
                              width: 1,
                            ),
                          ),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(12),
                            bottomRight: Radius.circular(12),
                          ),
                          // border: Border.all(color: isDarkMode ? AppColors.grey100Color :AppColors.lightBorderColor,width: 1),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Gap(12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: CommonText.medium(course.name, size: 15),
                            ),
                            Gap(7),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: CommonText.regular(
                                course.description,
                                size: 13,
                                color: isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.bodyTextColor,
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Gap(7),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CommonText.semiBold(
                                    '\$${course.courseFees.toString()}',
                                    size: 18,
                                    color: AppColors.primary500,
                                  ),
                                  Gap(20),
                                  SvgImageFromAsset(AppCommonIcon.starIcon),
                                  Gap(7),
                                  CommonText.semiBold(
                                    course.rate.toString(),
                                    size: 16,
                                    color: AppColors.secondary500,
                                  ),
                                ],
                              ),
                            ),
                            Gap(12),
                            CommonDivider(),
                            Gap(12),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              child: horizontalDetailView(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(12),
                          bottomLeft: Radius.circular(12),
                        ),
                        child: commonCacheImage(
                          course.image,
                          ImagePlaceHolder.imagePlaceHolderDark,
                          height: 200,
                          width: 250,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: isDarkMode
                                ? AppColors.mainDarkBgColor
                                : AppColors.lightBgColor,
                            border: Border(
                              top: BorderSide(
                                color: isDarkMode
                                    ? AppColors.grey100Color
                                    : AppColors.lightBorderColor,
                                width: 1,
                              ),
                              bottom: BorderSide(
                                color: isDarkMode
                                    ? AppColors.grey100Color
                                    : AppColors.lightBorderColor,
                                width: 1,
                              ),
                              right: BorderSide(
                                color: isDarkMode
                                    ? AppColors.grey100Color
                                    : AppColors.lightBorderColor,
                                width: 1,
                              ),
                            ),
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(12),
                              bottomRight: Radius.circular(12),
                            ),
                            // border: Border.all(color: isDarkMode ? AppColors.grey100Color :AppColors.lightBorderColor,width: 1),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                  top: 12,
                                  left: spacing,
                                  right: spacing,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          CommonText.medium(
                                            course.name,
                                            size: 18,
                                          ),
                                          Gap(5),

                                          Padding(
                                            padding: const EdgeInsets.only(
                                              right: 90,
                                            ),
                                            child: CommonText.regular(
                                              course.description,
                                              size: 16,
                                              color: isDarkMode
                                                  ? AppColors.bodyTextDarkColor
                                                  : AppColors.bodyTextColor,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    showMenuButton == true
                                        ? CourseApprovalsSecondMenuButton(
                                            course: course,
                                            editCourseOnTap:editCourseOnTap,
                                            viewCourseOnTap:
                                                editViewCourseOnTap,
                                            deleteCourseOnTap: deleteCourseOnTap,
                                          )
                                        : CourseApprovalsMenuButton(
                                            course: course,
                                            viewCourseOnTap: viewCourseOnTap,
                                            declinedOnTap: declinedOnTap,
                                            deleteOnTap: deleteOnTap,
                                          ),
                                  ],
                                ),
                              ),
                              Gap(12),
                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CommonText.semiBold(
                                      '\$${course.courseFees.toString()}',
                                      size: 20,
                                      color: AppColors.primary500,
                                    ),
                                    Gap(20),
                                    Row(
                                      children: [
                                        SvgImageFromAsset(
                                          AppCommonIcon.starIcon,
                                        ),
                                        Gap(7),
                                        CommonText.semiBold(
                                          course.rate.toString(),
                                          size: 16,
                                          color: AppColors.secondary500,
                                        ),
                                      ],
                                    ),
                                    Gap(20),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(32),
                                      child: commonCacheImage(
                                        course.instructorProfileImg,
                                        ImagePlaceHolder.imagePlaceHolderDark,
                                        height: 32,
                                        width: 32,
                                      ),
                                    ),
                                    Gap(7),
                                    CommonText.regular(
                                      course.instructorName,
                                      size: 17,
                                    ),
                                  ],
                                ),
                              ),
                              Gap(12),
                              CommonDivider(),

                              Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: spacing,
                                ),
                                child: Row(
                                  children: [
                                    Expanded(child: horizontalDetailView()),
                                    showSwitch == true
                                        ? customSwitch()
                                        : SizedBox(),
                                  ],
                                ),
                              ),
                              Gap(7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
          : mobileView
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(6),
                        topRight: Radius.circular(6),
                      ),
                      child: commonCacheImage(
                        course.image,
                        ImagePlaceHolder.imagePlaceHolderDark,
                        height: 170,
                        width: double.infinity,
                        //fit: BoxFit.contain
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: showMenuButton == true
                          ? CourseApprovalsSecondMenuButton(
                              course: course,
                              editCourseOnTap: editCourseOnTap,
                              viewCourseOnTap: editViewCourseOnTap,
                              deleteCourseOnTap: deleteCourseOnTap,
                            )
                          : CourseApprovalsMenuButton(
                              course: course,
                              viewCourseOnTap: viewCourseOnTap,
                              declinedOnTap: declinedOnTap,
                              deleteOnTap: deleteOnTap,
                            ),
                    ),
                  ],
                ),

                //   Gap(12),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.lightBgColor,
                    border: Border(
                      left: BorderSide(
                        color: isDarkMode
                            ? AppColors.grey100Color
                            : AppColors.lightBorderColor,
                        width: 1,
                      ),
                      bottom: BorderSide(
                        color: isDarkMode
                            ? AppColors.grey100Color
                            : AppColors.lightBorderColor,
                        width: 1,
                      ),
                      right: BorderSide(
                        color: isDarkMode
                            ? AppColors.grey100Color
                            : AppColors.lightBorderColor,
                        width: 1,
                      ),
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(12),
                      bottomRight: Radius.circular(12),
                    ),
                    // border: Border.all(color: isDarkMode ? AppColors.grey100Color :AppColors.lightBorderColor,width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Gap(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CommonText.medium(course.name, size: 15),
                      ),
                      Gap(7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: CommonText.regular(
                          course.description,
                          size: 13,
                          color: isDarkMode
                              ? AppColors.bodyTextDarkColor
                              : AppColors.bodyTextColor,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Gap(7),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            CommonText.semiBold(
                              '\$${course.courseFees.toString()}',
                              size: 18,
                              color: AppColors.primary500,
                            ),
                            Gap(20),
                            SvgImageFromAsset(AppCommonIcon.starIcon),
                            Gap(7),
                            CommonText.semiBold(
                              course.rate.toString(),
                              size: 16,
                              color: AppColors.secondary500,
                            ),
                            Gap(20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: commonCacheImage(
                                course.instructorProfileImg,
                                ImagePlaceHolder.imagePlaceHolderDark,
                                height: 24,
                                width: 24,
                              ),
                            ),
                            Gap(7),
                            Expanded(
                              child: CommonText.regular('Admin', size: 13),
                            ),
                            customSwitch(),
                            Gap(7),
                          ],
                        ),
                      ),
                      Gap(12),
                      CommonDivider(),
                      Gap(12),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: horizontalDetailView(),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                showCheckBox == true
                    ? Obx(
                        () => Checkbox(
                          value: course.isChecked.value,
                          onChanged: (value) {
                            course.isChecked.value = value!;
                          },
                        ),
                      )
                    : SizedBox(),
                Gap(course.isChecked.value == true ? 10 : 0),
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: commonCacheImage(
                    course.image,
                    ImagePlaceHolder.imagePlaceHolderDark,
                    height: 200,
                    width: 250,
                  ),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isDarkMode
                          ? AppColors.mainDarkBgColor
                          : AppColors.lightBgColor,
                      border: Border(
                        top: BorderSide(
                          color: isDarkMode
                              ? AppColors.grey100Color
                              : AppColors.lightBorderColor,
                          width: 1,
                        ),
                        bottom: BorderSide(
                          color: isDarkMode
                              ? AppColors.grey100Color
                              : AppColors.lightBorderColor,
                          width: 1,
                        ),
                        right: BorderSide(
                          color: isDarkMode
                              ? AppColors.grey100Color
                              : AppColors.lightBorderColor,
                          width: 1,
                        ),
                      ),
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(12),
                        bottomRight: Radius.circular(12),
                      ),
                      // border: Border.all(color: isDarkMode ? AppColors.grey100Color :AppColors.lightBorderColor,width: 1),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(
                            top: 12,
                            left: spacing,
                            right: spacing,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    CommonText.medium(course.name, size: 18),
                                    Gap(5),

                                    Padding(
                                      padding: const EdgeInsets.only(right: 90),
                                      child: CommonText.regular(
                                        course.description,
                                        size: 16,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              showMenuButton == true
                                  ? CourseApprovalsSecondMenuButton(
                                      course: course,
                                      editCourseOnTap: editCourseOnTap,
                                      viewCourseOnTap: editViewCourseOnTap,
                                      deleteCourseOnTap: deleteCourseOnTap,
                                    )
                                  : CourseApprovalsMenuButton(
                                      course: course,
                                      viewCourseOnTap: viewCourseOnTap,
                                      declinedOnTap: declinedOnTap,
                                      deleteOnTap: deleteOnTap,
                                    ),
                            ],
                          ),
                        ),
                        Gap(12),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonText.semiBold(
                                '\$${course.courseFees.toString()}',
                                size: 20,
                                color: AppColors.primary500,
                              ),
                              Gap(20),
                              showRate == true
                                  ? Row(
                                      children: [
                                        SvgImageFromAsset(
                                          AppCommonIcon.starIcon,
                                        ),
                                        Gap(7),
                                        CommonText.semiBold(
                                          course.rate.toString(),
                                          size: 16,
                                          color: AppColors.secondary500,
                                        ),
                                      ],
                                    )
                                  : SizedBox(),
                              Gap(20),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: commonCacheImage(
                                  course.instructorProfileImg,
                                  ImagePlaceHolder.imagePlaceHolderDark,
                                  height: 32,
                                  width: 32,
                                ),
                              ),
                              Gap(7),
                              CommonText.regular(
                                course.instructorName,
                                size: 17,
                              ),
                            ],
                          ),
                        ),
                        Gap(12),
                        CommonDivider(),

                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: spacing),
                          child: Row(
                            children: [
                              Expanded(child: horizontalDetailView()),
                              showSwitch == true ? customSwitch() : SizedBox(),
                            ],
                          ),
                        ),
                        Gap(5),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }



  Widget horizontalDetailView() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            commonDetail(CommonImageAssets.book, course.courseCategory),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.language, course.language),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.video, ApprovalsStrings.videoClass),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.cap,
              '${course.noOfSession.toString()} Sessions',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.video,
              '${course.noOfLectures.toString()} Lectures',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(AppCommonIcon.calenderIcon, course.date),
          ],
        ),
      ),
    );
  }

  Widget commonDetail(String image, title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(
          image,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(
            isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
            BlendMode.srcIn,
          ),
        ),
        Gap(10),
        CommonText.regular(
          title,
          size: 14,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
        ),
      ],
    );
  }

  Widget verticalDivider() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: 20,
      width: 1,
      color: isDarkMode ? AppColors.grey100Color : AppColors.headingsLightColor,
    );
  }

  Widget customSwitch() {
    RxBool isSwitch = false.obs;
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Obx(
        () => Transform.scale(
          scale: 0.8,
          child: CupertinoSwitch(
            value: isSwitch.value,
            onChanged: (value) {
              isSwitch.value = value;
            },
            activeTrackColor: AppColors.primary500,
            thumbColor: AppColors.white,
            inactiveThumbColor: isDarkMode
                ? AppColors.mainDarkBgColor
                : AppColors.white,
            inactiveTrackColor: isDarkMode
                ? AppColors.greyDarkColor
                : AppColors.background100,
          ),
        ),
      ),
    );
  }
}





