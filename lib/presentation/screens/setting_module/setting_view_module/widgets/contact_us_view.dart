import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/alerts/alerts.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../approvals_module/approvals_course_view/widgets/common_delete_dialog_box.dart';
import '../controller/setting_view_controller.dart';

class ContactUsView extends StatefulWidget {
  const ContactUsView({super.key});

  @override
  State<ContactUsView> createState() => _ContactUsViewState();
}

class _ContactUsViewState extends State<ContactUsView> {
  SettingViewController controller = Get.put(SettingViewController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Padding(
      padding: const EdgeInsets.only(left: 20,top: 20),
      child: ResponsiveGridRow(
        children: List.generate(controller.setting.value.contactList.length, (
          index,
        ) {
          final data = controller.setting.value.contactList[index];
          return ResponsiveGridCol(
            lg: 4,
            xs: 12,

            child: Container(
              height: mobileView?null:306,
              margin: EdgeInsetsGeometry.only(right: 20,bottom: 20),
              decoration: BoxDecoration(
                color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
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
                              CommonText.medium(data.name, size: 16),
                              Gap(3),
                              CommonText.regular(
                                data.name,
                                size: 16,
                                color: isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.bodyTextColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(3),
                              CommonText.regular(
                                data.phonenumber,
                                size: 16,
                                color: AppColors.greyTextColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            commonDialogBox(
                              context: context,
                              child: SizedBox(
                                width: 560,
                                child: CommonDeleteDialogBox(
                                  tittle: SettingViewStrings.deleteContact,
                                  subtitle: SettingViewStrings.deleteContactDes,
                                  doneOnPressed: () {
                             setState(() {

                               if (index <
                                   controller
                                       .setting
                                       .value
                                       .contactList
                                       .length) {
                                 controller.setting.value.contactList
                                     .removeAt(index);
                                 controller.setting.refresh();
                               }
                               Navigator.of(
                                 context,
                                 rootNavigator: true,
                               ).pop();

                               showSuccessMessage(
                                 context: context,
                                 title: 'Contact Deleted Successfully',
                                 content: '',
                               );
                             });
                                  },
                                ),
                              ),
                            );
                          },
                          child: Container(
                            height: 36,
                            width: 36,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.error500
                                  : AppColors.lightBgColor,
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.transparent
                                    : AppColors.lightBorderColor,
                                width: 1,
                              ),
                              borderRadius: BorderRadius.circular(7),
                            ),
                            child: Center(
                              child: SvgImageFromAsset(
                                AppCommonIcon.deleteIcon,
                                colorFilter: ColorFilter.mode(
                                  isDarkMode
                                      ? AppColors.white
                                      : AppColors.error500,
                                  BlendMode.srcIn,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 15,
                    ),
                    child: CommonText.regular(
                      data.address,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                      maxLines: 7,
                      overflow: TextOverflow.ellipsis,
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
}
