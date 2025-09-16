import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../controller/setting_view_controller.dart';
import '../model/faq_model.dart';

class FaqView extends StatefulWidget {
  const FaqView({super.key});

  @override
  State<FaqView> createState() => _FaqViewState();
}

class _FaqViewState extends State<FaqView> {
  SettingViewController controller = Get.put(SettingViewController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.only(left: 20, bottom: 20),
      child: ResponsiveGridRow(
        children: List.generate(controller.setting.value.faqList.length, (
          index,
        ) {
          final faq = controller.setting.value.faqList[index];
          return ResponsiveGridCol(
            lg: 6,
            xs: 12,
            child: Container(
              margin: EdgeInsetsGeometry.only(right: 20, top: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                  width: 1,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: CommonText.regular(
                            faq.question,
                            size: 16,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Gap(20),
                        commonSwitch(faq),
                        Gap(25),
                        menuButton(),
                      ],
                    ),
                  ),
                  CommonDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: CommonText.light(
                      faq.answer,
                      size: 14,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
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

  Widget commonSwitch(FaqModel faq) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SizedBox(
      height: 17,
      width: 17,
      child: Obx(
        () => Transform.scale(
          scale: 0.7,
          child: CupertinoSwitch(
            value: faq.isSwitch.value,
            onChanged: (value) {
              setState(() {
                faq.isSwitch.value = value;
              });
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

  Widget menuButton() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),

      padding: EdgeInsetsGeometry.zero,
      menuPadding: EdgeInsetsGeometry.zero,
      position: PopupMenuPosition.under,
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
        decoration: commonCardDecoration(7),
        child: Center(
          child: SvgImageFromAsset(
            AppCommonIcon.moreIcon,
            colorFilter: ColorFilter.mode(
              isDarkMode ? AppColors.white : AppColors.headingsColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    );
  }
}
