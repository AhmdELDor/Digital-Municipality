import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';

class CourseApprovalsSecondMenuButton extends StatelessWidget {
  final CourseModel course;
  final VoidCallback? editCourseOnTap;
  final VoidCallback? viewCourseOnTap;
  final VoidCallback? deleteCourseOnTap;

  const CourseApprovalsSecondMenuButton({
    super.key,
    required this.course,
    this.editCourseOnTap,
    this.viewCourseOnTap,
    this.deleteCourseOnTap,
  });

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);

    return PopupMenuButton<int>(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      onSelected: (value) {
        // Use GetX navigation to avoid context errors
        if (value == 1) {
          editCourseOnTap?.call();
        } else if (value == 2) {
          viewCourseOnTap?.call();
        } else if (value == 3) {
          deleteCourseOnTap?.call();
        }
      },
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
            colorFilter: const ColorFilter.mode(
              AppColors.white,
              BlendMode.srcIn,
            ),
          ),
        ),
      )
          : commonPopTextView(AppCommonIcon.moreIcon),
      padding: EdgeInsets.zero,
      menuPadding: EdgeInsets.zero,
      itemBuilder: (context) => [
        PopupMenuItem<int>(
          value: 1,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(AppCommonIcon.editIcon, CourseManagementStrings.edit, null),
          ),
        ),
        PopupMenuItem<int>(
          value: 2,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(AppCommonIcon.showPasswordIcon, CourseManagementStrings.view, null),
          ),
        ),
        PopupMenuItem<int>(
          value: 3,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(AppCommonIcon.deleteIcon, ApprovalsStrings.delete, null),
          ),
        ),
      ],
    );
  }
}

