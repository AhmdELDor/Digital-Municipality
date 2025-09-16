import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/app_route.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/widgets/common_cache_image.dart';
import '../../../approvals_module/approvals_course_view/widgets/instructor_menu_button.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';

class InstructorManagementDetailView extends StatefulWidget {
  final InstructorModel data;
  final void Function() deleteOnTap;
  const InstructorManagementDetailView({
    super.key,
    required this.data,
    required this.deleteOnTap,
  });

  @override
  State<InstructorManagementDetailView> createState() =>
      _InstructorManagementDetailViewState();
}

class _InstructorManagementDetailViewState
    extends State<InstructorManagementDetailView> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Container(
      decoration: commonCardDecoration(15),
      margin: EdgeInsets.only(bottom: 20, left: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            decoration: BoxDecoration(
              color: isDarkMode
                  ? AppColors.cardDarkBg2Color
                  : AppColors.lightBgColor,
              borderRadius: BorderRadiusGeometry.only(
                topRight: Radius.circular(15),
                topLeft: Radius.circular(15),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: SizedBox(
                height: 68,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(48),
                      child: commonCacheImage(
                        widget.data.image,
                        ImagePlaceHolder.imagePlaceHolderDark,
                        height: 48,
                        width: 48,
                      ),
                    ),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CommonText.medium(
                              widget.data.name,
                              size: 16,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Gap(7),

                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 3,
                                  backgroundColor:
                                      widget.data.status == "Active"
                                      ? AppColors.success500
                                      : widget.data.status == "Suspended"
                                      ? AppColors.error500
                                      : AppColors.secondary500,
                                ),
                                Gap(3),
                                Expanded(
                                  child: CommonText.medium(
                                    widget.data.status,
                                    size: 14,
                                    color: widget.data.status == "Active"
                                        ? AppColors.success500
                                        : widget.data.status == "Suspended"
                                        ? AppColors.error500
                                        : AppColors.secondary500,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),

                    InstructorMenuButton(instructorData: widget.data,
                    deleteOnTap: widget.deleteOnTap,),
                  ],
                ),
              ),
            ),
          ),
          mobileView ? SizedBox() : CommonDivider(),
          Gap(15),
          if (mobileView)
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    children: [
                      CommonText.medium(
                        ApprovalsStrings.contactDetails,
                        size: 15,
                      ),
                      Spacer(),
                      CommonText.medium(
                        InstructorManagementStrings.courseDetails,
                        size: 15,
                      ),
                    ],
                  ),
                ),
                Gap(15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SvgImageFromAsset(
                                  AppCommonIcon.emailIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                Gap(10),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      CommonText.regular(
                                        widget.data.email,
                                        size: 14,
                                        color: isDarkMode
                                            ? AppColors.bodyTextDarkColor
                                            : AppColors.bodyTextColor,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            Gap(10),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SvgImageFromAsset(
                                  AppCommonIcon.callIcon,
                                  height: 20,
                                  width: 20,
                                ),
                                Gap(10),
                                Expanded(
                                  child: CommonText.regular(
                                    widget.data.phoneNo,
                                    size: 15,
                                    color: isDarkMode
                                        ? AppColors.bodyTextDarkColor
                                        : AppColors.bodyTextColor,
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      Expanded(child: courseDetailList()),
                    ],
                  ),
                ),
              ],
            )
          else
            desktopView(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: PrimaryButton(
              height: 36,
              onPressed: () {
                context.go(
                  '${AppRouteName.instructorManagementView}/${AppRouteName.instructorManagementDetailView}',
                  extra: widget.data,
                );
              },
              label: ApprovalsStrings.viewProfile,
              textSize: 15,
              textWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  desktopView() {
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: CommonText.medium(ApprovalsStrings.contactDetails, size: 15),
        ),
        Gap(15),
        commonDetail(AppCommonIcon.emailIcon, widget.data.email),
        Gap(10),
        commonDetail(AppCommonIcon.callIcon, widget.data.phoneNo),
        Gap(10),
        mobileView ? SizedBox() : CommonDivider(),
        Gap(mobileView ? 0 : 15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: CommonText.medium(
            InstructorManagementStrings.courseDetails,
            size: 15,
          ),
        ),
        Gap(15),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: courseDetailList(),
        ),
      ],
    );
  }

  Widget courseDetailList() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SvgImageFromAsset(CommonImageAssets.book, height: 20, width: 20),
        Gap(10),
        CommonText.regular(
          '${widget.data.noOfCourses.toString()} Courses',
          size: 15,
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  // menuButton(void Function() deleteOnTap) {
  //   bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  //   return PopupMenuButton(
  //     color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
  //     child: commonPopTextView(AppCommonIcon.moreIcon),
  //
  //     itemBuilder: (context) => [
  //       PopupMenuItem(
  //         value: 1,
  //         onTap: () {
  //           commonDialogBox(
  //             context: context,
  //             child: SizedBox(
  //               width: 560,
  //               child: CommonDialogView(
  //                 image: CommonImageAssets.deActiveSecurity,
  //                 title: DeActiveStrings.instructorAccountDeactivation,
  //                 subtitle: DeActiveStrings.instructorAccountDeactivationDes,
  //                 buttonBackgroundColor: AppColors.warning500,
  //                 buttonName: DeActiveStrings.deactivate,
  //                 onPressed: () {
  //                   Navigator.of(
  //                     context,
  //                     rootNavigator: true,
  //                   ).pop();
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //           child: commonDeviceView(
  //             CommonImageAssets.deActive,
  //             InstructorManagementStrings.deactive,
  //             null,
  //           ),
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: 2,
  //         onTap: () {
  //           commonDialogBox(
  //             context: context,
  //             child: SizedBox(
  //               width: 560,
  //               child: CommonDialogView(
  //                 image: CommonImageAssets.suspendImg,
  //                 title: SuspendStrings.instructorAccountSuspension,
  //                 subtitle: SuspendStrings.instructorAccountSuspensionDes,
  //                 buttonBackgroundColor: AppColors.error500,
  //                 buttonName: SuspendStrings.suspend,
  //                 onPressed: () {
  //                   Navigator.of(
  //                     context,
  //                     rootNavigator: true,
  //                   ).pop();
  //                 },
  //               ),
  //             ),
  //           );
  //         },
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //           child: commonDeviceView(
  //             CommonImageAssets.suspend,
  //             InstructorManagementStrings.suspend,
  //             null,
  //           ),
  //         ),
  //       ),
  //       PopupMenuItem(
  //         value: 3,
  //         onTap: deleteOnTap,
  //         child: Padding(
  //           padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
  //           child: commonDeviceView(
  //             AppCommonIcon.deleteIcon,
  //             ApprovalsStrings.delete,
  //             null,
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  Widget commonDetail(String image, title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgImageFromAsset(image, height: 20, width: 20),
          Gap(10),
          Expanded(
            child: CommonText.regular(
              title,
              size: 15,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
        ],
      ),
    );
  }
}
