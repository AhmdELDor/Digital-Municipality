import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../controller/notification_controller.dart';
import '../model/notification_model.dart';

class NotificationListView extends StatelessWidget {
  final NotificationController controller = Get.put(NotificationController());

  NotificationListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.currentTabList;

      if (list.isEmpty) {
        return const Center(child: Text("No notifications"));
      }

      return ListView.separated(
        itemCount: list.length,
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        itemBuilder: (context, index) {
          final data = list[index];
          return notificationView(data, context);
        },
        separatorBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: CommonDivider(),
          );
        },
      );
    });
  }
}

notificationView(NotificationModel notification, BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  var mobileView = ResponsiveView.isMobile(context);
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      CircleAvatar(
        radius: notification.read == true ? 0 : 3,
        backgroundColor: notification.read == true
            ? Colors.transparent
            : AppColors.success500,
      ),
      Gap(notification.read == true ? 0 : 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CommonText.regular(notification.title, size: 17),
            Gap(7),
            CommonText.regular(
              notification.title,
              size: 15,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
          ],
        ),
      ),
      mobileView
          ? PopupMenuButton(
              color: isDarkMode
                  ? AppColors.mainDarkBgColor
                  : AppColors.lightBgColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(9),
              ),
              child: commonPopTextView(AppCommonIcon.moreIcon),

              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 1,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: commonDeviceView(
                      AppCommonIcon.likeIcon,
                      NotesListStrings.useful,
                      null
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 2,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: commonDeviceView(
                      AppCommonIcon.disLikeIcon,
                      NotesListStrings.notUseful,
                        null
                    ),
                  ),
                ),
                PopupMenuItem(
                  value: 3,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(8, 0, 0, 0),
                    child: commonDeviceView(
                      AppCommonIcon.deleteIcon,
                      NotesListStrings.delete,
                     ColorFilter.mode( AppColors.error500, BlendMode.srcIn)
                    ),
                  ),
                ),
              ],
            )
          : Row(
              children: [
                commonPopTextView(AppCommonIcon.likeIcon),
                Gap(20),
                commonPopTextView(AppCommonIcon.disLikeIcon),
                Gap(20),

                commonPopTextView(AppCommonIcon.deleteIcon),
              ],
            ),
    ],
  );
}

commonPopTextView(String image) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Container(
    height: 36,
    width: 36,
    decoration: BoxDecoration(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      borderRadius: BorderRadius.circular(6),
      border: Border.all(
        color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
      ),
    ),
    child: Center(child: SvgImageFromAsset(image)),
  );
}

commonDeviceView(String image, title, ColorFilter? colorFilter) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Row(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      SvgImageFromAsset(
        image,
        colorFilter: colorFilter??ColorFilter.mode(
          isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
          BlendMode.srcIn,
        ),
      ),
      Gap(12),
      CommonText.regular(
        title,
        size: 15,
        color: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
      ),
    ],
  );
}
