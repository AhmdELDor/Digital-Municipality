import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import 'all_dialog_box.dart';

class CourseApprovalsMenuButton extends StatefulWidget {
  final CourseModel course;
  final void Function()? viewCourseOnTap, declinedOnTap, deleteOnTap;
  const CourseApprovalsMenuButton({
    super.key,
    this.viewCourseOnTap,
    this.declinedOnTap,
    required this.course,
    this.deleteOnTap,
  });

  @override
  State<CourseApprovalsMenuButton> createState() =>
      _CourseApprovalsMenuButtonState();
}

class _CourseApprovalsMenuButtonState extends State<CourseApprovalsMenuButton> {
  @override
  Widget build(BuildContext context) {
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
      position: PopupMenuPosition.under,

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: widget.viewCourseOnTap,
          // onTap: () {
          //   context.go(
          //     '${AppRouteName.approvalsView}/${AppRouteName.courseApprovalsDetailView}',
          //     extra: {'data': course, 'title': 'view'},
          //   );
          // },
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
                width: 560,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                    horizontal: 20,
                  ),
                  child: CourseApproveDialog(
                    image: CommonImageAssets.courseApprove,
                    title: CourseApproveDialogStrings.courseApproved,
                    subtitle: CourseApproveDialogStrings.courseApprovedDes,
                    buttonName: CourseApproveDialogStrings.goToCourse,
                    onPressed: () {
                      Navigator.of(context, rootNavigator: true).pop();
                    },
                  ),
                ),
              ),
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
          onTap: widget.declinedOnTap,

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
          onTap: widget.deleteOnTap,
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
}
