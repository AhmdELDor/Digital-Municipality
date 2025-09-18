import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../model/university_model.dart';

class UniversityMenuButton extends StatefulWidget {
  final UniversityModel universityData;
  final void Function()? approveOnTap, declinedOnTap, deleteOnTap;
  const UniversityMenuButton({
    super.key,
    this.approveOnTap,
    this.declinedOnTap,
    required this.universityData,
    this.deleteOnTap,
  });

  @override
  State<UniversityMenuButton> createState() =>
      _UniversityMenuButtonState();
}

class _UniversityMenuButtonState extends State<UniversityMenuButton> {
  @override
  Widget build(BuildContext context) {
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
          onTap: widget.approveOnTap,
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
          value: 2,
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
