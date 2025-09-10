import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_cache_image.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../../class_management_view/model/class_model.dart';
import '../controller/today_class_controller.dart';

Widget usersDropDown() {
  TodayClassController controller = Get.put(TodayClassController());
  return Obx(
    () => CustomDropdownFormField<String>(
      hintText: "Select",
      items: controller.usersList,
      value: controller.selectedUser.value.isEmpty
          ? null
          : controller.selectedUser.value,
      onChanged: (val) {
        controller.selectedUser.value = val ?? '';
      },
      validator: (val) => val == null || val.isEmpty ? "Please select" : null,
    ),
  );
}

Widget courseCategoryDropDown() {
  TodayClassController controller = Get.put(TodayClassController());
  return Obx(
    () => CustomDropdownFormField<String>(
      hintText: "Course",
      items: controller.courseList,
      value: controller.selectedCourse.value.isEmpty
          ? null
          : controller.selectedCourse.value,
      onChanged: (val) {
        controller.selectedCourse.value = val ?? '';
      },
      validator: (val) => val == null || val.isEmpty ? "Course" : null,
    ),
  );
}

Widget menuButton(BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return PopupMenuButton(
    color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),

    padding: EdgeInsetsGeometry.zero,
    menuPadding: EdgeInsetsGeometry.zero,

    itemBuilder: (context) => [
      PopupMenuItem(
        value: 1,
        onTap: () {},
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
        onTap: () {},
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
          child: commonDeviceView(
            AppCommonIcon.deleteIcon,
            NotesListStrings.delete,
            null,
          ),
        ),
      ),
    ],
    child: Container(
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
          colorFilter: ColorFilter.mode(AppColors.white, BlendMode.srcIn),
        ),
      ),
    ),
  );
}

Widget todayClassView(ClassModel data, BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  return Container(
    margin: EdgeInsets.only(right: 20, bottom: 20),
    decoration: commonCardDecoration(12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(5.0),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: commonCacheImage(
                  data.image,
                  ImagePlaceHolder.imagePlaceHolderDark,
                  height: 175,
                  width: double.infinity,
                  //fit: BoxFit.fill
                ),
              ),
              Positioned(right: 10, top: 10, child: menuButton(context)),
            ],
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CommonText.medium(data.name, size: 18),
        ),
        Gap(7),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CommonText.regular(
            data.title,
            size: 15,
            color: AppColors.greyTextColor,
          ),
        ),
        Gap(15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              mobileView
                  ? deviceCalenderView(CommonImageAssets.calender)
                  : Container(
                      height: 36,
                      width: 36,
                      decoration: commonCardDecoration(7),
                      child: Center(
                        child: SvgImageFromAsset(
                          AppCommonIcon.clockIcon,
                          colorFilter: ColorFilter.mode(
                            isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
              Gap(7),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText.regular(data.time, size: 15),

                  CommonText.regular(
                    mobileView
                        ? TodayClassManagementStrings.date
                        : TodayClassManagementStrings.time,
                    size: 13,
                    color: AppColors.greyTextColor,
                  ),
                ],
              ),
              mobileView
                  ? Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          mobileView
                              ? deviceCalenderView(AppCommonIcon.clockIcon)
                              : Container(
                                  height: 36,
                                  width: 36,
                                  decoration: commonCardDecoration(7),
                                  child: Center(
                                    child: SvgImageFromAsset(
                                      AppCommonIcon.userIcon,
                                      colorFilter: ColorFilter.mode(
                                        isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                          Gap(10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              CommonText.regular(
                                mobileView ? data.time : data.instructor,
                                size: 15,
                              ),

                              CommonText.regular(
                                mobileView
                                    ? TodayClassManagementStrings.time
                                    : CourseApprovalsDetailStrings.instructor,
                                size: 13,
                                color: AppColors.greyTextColor,
                              ),
                            ],
                          ),
                        ],
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
        Gap(15),
        mobileView ? SizedBox() : CommonDivider(),
        Gap(15),
        mobileView
            ? SizedBox()
            : Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    mobileView
                        ? deviceCalenderView(AppCommonIcon.clockIcon)
                        : Container(
                            height: 36,
                            width: 36,
                            decoration: commonCardDecoration(7),
                            child: Center(
                              child: SvgImageFromAsset(
                                AppCommonIcon.userIcon,
                                colorFilter: ColorFilter.mode(
                                  isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                    Gap(10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CommonText.regular(
                          mobileView ? data.time : data.instructor,
                          size: 15,
                        ),

                        CommonText.regular(
                          mobileView
                              ? TodayClassManagementStrings.time
                              : CourseApprovalsDetailStrings.instructor,
                          size: 13,
                          color: AppColors.greyTextColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
        mobileView ? SizedBox() : Gap(20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: PrimaryButton(
            height: 42,
            textWeight: FontWeight.w600,
            textSize: 18,
            onPressed: () {},
            label: TodayClassManagementStrings.remindInstructor,
          ),
        ),
        Gap(12),
      ],
    ),
  );
}

deviceCalenderView(String image) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(
      color: isDarkMode ? AppColors.cardDarkBg2Color : AppColors.primary100,
      borderRadius: BorderRadius.circular(3),
    ),
    child: Center(
      child: SvgImageFromAsset(
        image,
        colorFilter: ColorFilter.mode(AppColors.primary500, BlendMode.srcIn),
      ),
    ),
  );
}
