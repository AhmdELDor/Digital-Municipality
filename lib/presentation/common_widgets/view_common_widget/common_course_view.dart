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
import '../../screens/approvals_module/approvals_module/widgets/all_dialog_box.dart';
import '../../screens/dashboard_module/dashboard/model/course_model.dart';
import '../../screens/dashboard_module/dashboard/widgets/add_note_dailog_box.dart';
import '../../screens/dashboard_module/notification/widgets/notification_list_view.dart';
import 'common_card_decoration.dart';
import 'common_dialog_box.dart';

class CommonCourseView extends StatefulWidget {
  final CourseModel course;
  const CommonCourseView({super.key, required this.course});

  @override
  State<CommonCourseView> createState() => _CommonCourseViewState();
}

class _CommonCourseViewState extends State<CommonCourseView> {
  RxBool isSwitch = false.obs;
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    double spacing = 20;
    return Container(
      decoration: commonCardDecoration(12),
      margin: EdgeInsetsGeometry.only(bottom: 15),
      child: mobileView
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
                        widget.course.image,
                        ImagePlaceHolder.imagePlaceHolderDark,
                        height: 165,
                        width: double.infinity,
                        //fit: BoxFit.contain
                      ),
                    ),
                    Positioned(
                      top: 10,
                      right: 10,
                      child: menuButton(widget.course),
                    ),
                  ],
                ),
                Gap(12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  child: CommonText.medium(widget.course.name, size: 15),
                ),
                Gap(7),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  child: CommonText.regular(
                    widget.course.description,
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
                  padding: EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      CommonText.semiBold(
                        '\$${widget.course.courseFees.toString()}',
                        size: 18,
                        color: AppColors.primary500,
                      ),
                      Gap(20),
                      SvgImageFromAsset(AppCommonIcon.starIcon),
                      Gap(7),
                      CommonText.semiBold(
                        widget.course.rate.toString(),
                        size: 16,
                        color: AppColors.secondary500,
                      ),
                      Gap(20),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(32),
                        child: commonCacheImage(
                          widget.course.instructorProfileImg,
                          ImagePlaceHolder.imagePlaceHolderDark,
                          height: 24,
                          width: 24,
                        ),
                      ),
                      Gap(7),
                      Expanded(child: CommonText.regular('Admin', size: 13)),
                      SizedBox(
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
                              inactiveThumbColor: AppColors.white,
                              inactiveTrackColor: AppColors.background100,
                            ),
                          ),
                        ),
                      ),
                      Gap(7),
                    ],
                  ),
                ),
                Gap(12),
                CommonDivider(),
                Gap(12),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 17,),
                  child: horizontalDetailView(),
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
                    topRight: Radius.circular(12),
                  ),
                  child: commonCacheImage(
                    widget.course.image,
                    ImagePlaceHolder.imagePlaceHolderDark,
                    height: 200,
                    width: 250,
                  ),
                ),
                Expanded(
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
                                  CommonText.medium(
                                    widget.course.name,
                                    size: 18,
                                  ),
                                  Gap(5),

                                  Padding(
                                    padding: const EdgeInsets.only(right: 90),
                                    child: CommonText.regular(
                                      widget.course.description,
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
                            menuButton(widget.course),
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
                              '\$${widget.course.courseFees.toString()}',
                              size: 20,
                              color: AppColors.primary500,
                            ),
                            Gap(20),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(32),
                              child: commonCacheImage(
                                widget.course.instructorProfileImg,
                                ImagePlaceHolder.imagePlaceHolderDark,
                                height: 32,
                                width: 32,
                              ),
                            ),
                            Gap(7),
                            CommonText.regular(
                              widget.course.instructorName,
                              size: 17,
                            ),
                          ],
                        ),
                      ),
                      Gap(12),
                      CommonDivider(),

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: spacing),
                        child: horizontalDetailView(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget menuButton(CourseModel course) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: mobileView
          ? Container(
              height: 32,
              width: 32,
              decoration: BoxDecoration(
                color: Colors.transparent,

                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: AppColors.lightBorderColor),
              ),
              child: Center(
                child: SvgImageFromAsset(
                  AppCommonIcon.moreIcon,
                  colorFilter: ColorFilter.mode(
                    AppColors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            )
          : commonPopTextView(AppCommonIcon.moreIcon),
      padding: EdgeInsetsGeometry.zero,
      menuPadding: EdgeInsetsGeometry.zero,

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            //print( course.name);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.showPasswordIcon,
              DashboardViewStrings.viewCourse,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 2,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                  width: 361,
                  child: CourseApproveDialog()),
            );
           // Navigator.pop(context);
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.approveIcon,
              ApprovalsStrings.approve,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                  width: 361,
                  child: CourseDeclineDialog()),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              AppCommonIcon.declineIcon,
              ApprovalsStrings.decline,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 4,
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

  Widget horizontalDetailView() {

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,

      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            commonDetail(CommonImageAssets.book, widget.course.courseCategory),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.language, widget.course.language),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(CommonImageAssets.video, ApprovalsStrings.videoClass),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.cap,
              '${widget.course.noOfSession.toString()} Sessions',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(
              CommonImageAssets.video,
              '${widget.course.noOfLectures.toString()} Lectures',
            ),
            Gap(12),
            verticalDivider(),
            Gap(12),
            commonDetail(AppCommonIcon.calenderIcon, widget.course.date),
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
}



