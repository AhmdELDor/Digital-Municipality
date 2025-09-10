import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../../../instructor_management_module/instructor_management_view/widgets/add_instructor_view.dart';

class InstructorMenuButton extends StatefulWidget {
  final InstructorModel instructorData;
  final void Function()? approveOnTap, declinedOnTap, deleteOnTap;
  const InstructorMenuButton({
    super.key,
    this.approveOnTap,
    this.declinedOnTap,
    required this.instructorData,
    this.deleteOnTap,
  });

  @override
  State<InstructorMenuButton> createState() =>
      _InstructorMenuButtonState();
}

class _InstructorMenuButtonState extends State<InstructorMenuButton> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: commonPopTextView(AppCommonIcon.moreIcon),

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
          onTap: () {
            commonDialogBox(
              context: context,
              child: SizedBox(
                width: 560,
                child: CommonDialogView(
                  image: CommonImageAssets.deActiveSecurity,
                  title: DeActiveStrings.instructorAccountDeactivation,
                  subtitle: DeActiveStrings.instructorAccountDeactivationDes,
                  buttonBackgroundColor: AppColors.warning500,
                  buttonName: DeActiveStrings.deactivate,
                  onPressed: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop();
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              CommonImageAssets.deActive,
              InstructorManagementStrings.deactive,
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
                child: CommonDialogView(
                  image: CommonImageAssets.suspendImg,
                  title: SuspendStrings.instructorAccountSuspension,
                  subtitle: SuspendStrings.instructorAccountSuspensionDes,
                  buttonBackgroundColor: AppColors.error500,
                  buttonName: SuspendStrings.suspend,
                  onPressed: () {
                    Navigator.of(
                      context,
                      rootNavigator: true,
                    ).pop();
                  },
                ),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
            child: commonDeviceView(
              CommonImageAssets.suspend,
              InstructorManagementStrings.suspend,
              null,
            ),
          ),
        ),
        PopupMenuItem(
          value: 3,
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
