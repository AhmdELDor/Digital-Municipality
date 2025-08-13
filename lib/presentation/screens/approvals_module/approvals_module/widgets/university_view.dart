import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/widgets/common_cache_image.dart';
import '../../../dashboard_module/notification/widgets/notification_list_view.dart';
import '../model/university_model.dart';

class UniversityView extends StatefulWidget {
  final UniversityModel data;
  const UniversityView({super.key, required this.data});

  @override
  State<UniversityView> createState() => _UniversityViewState();
}

class _UniversityViewState extends State<UniversityView> {
  final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 375,
      decoration: commonCardDecoration(15),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, ),
              child: SizedBox(
                height: 75,
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
                        padding: const EdgeInsets.symmetric(horizontal: 10,),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CommonText.medium(
                                widget.data.name,
                                size: 15,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(7),
                              CommonText.regular(
                                widget.data.date,
                                size: 13,
                                color: isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.bodyTextColor,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    menuButton(),
                  ],
                ),
              ),
            ),
          ),
          CommonDivider(),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CommonText.medium(ApprovalsStrings.contactDetails, size: 15),
          ),
          Gap(15),
          commonDetail(AppCommonIcon.emailIcon, widget.data.email),
          Gap(10),
          commonDetail(AppCommonIcon.callIcon, widget.data.phoneNo),
          Gap(15),
          CommonDivider(),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: CommonText.medium(
              ApprovalsStrings.verificationDetails,
              size: 15,
            ),
          ),
          Gap(15),
          ListView.builder(
            itemCount: widget.data.verificationDetailList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: commonDetail(
                  AppCommonIcon.documentIcon,
                  widget.data.verificationDetailList[index],
                ),
              );
            },
          ),
          Gap(15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: PrimaryButton(
              height: 36,
              onPressed: () {},
              label: ApprovalsStrings.viewProfile,
              textSize: 15,
              textWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
  menuButton() {
    return PopupMenuButton(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
      child: commonPopTextView(AppCommonIcon.moreIcon),

      itemBuilder: (context) => [
        PopupMenuItem(
          value: 1,
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
  Widget commonDetail(String image, title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgImageFromAsset(image, height: 16, width: 16),
          Gap(10),
          Expanded(
            child: CommonText.regular(
              title,
              size: 14,
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
