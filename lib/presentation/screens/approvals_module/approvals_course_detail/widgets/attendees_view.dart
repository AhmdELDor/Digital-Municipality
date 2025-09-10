import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../controller/approvals_course_detail_controller.dart';

class AttendeesView extends StatefulWidget {
  const AttendeesView({super.key});

  @override
  State<AttendeesView> createState() => _AttendeesViewState();
}

class _AttendeesViewState extends State<AttendeesView> {
  final CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    bool mobileView = ResponsiveView.isMobile(context);
    return ResponsiveGridRow(
      children: List.generate(controller.data.value.attendanceList.length, (
        index,
      ) {
        final data = controller.data.value.attendanceList[index];
        return ResponsiveGridCol(
          lg: 6,
          xs: 12,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              decoration: BoxDecoration(
                color: isDarkMode?AppColors.mainDarkBgColor:AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color:  isDarkMode?AppColors.grey100Color:AppColors.lightBorderColor, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(64),
                          child: commonCacheImage(
                            data.image,
                            ImagePlaceHolder.imagePlaceHolderDark,
                            height:mobileView?44: 64,
                            width: mobileView?44:64,
                          ),
                        ),  Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.medium(
                                data.name,
                                size: 18,
                                color: isDarkMode
                                    ? AppColors.bodyTextDarkColor
                                    : AppColors.bodyTextColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Gap(5),
                              CommonText.regular(
                                data.joiningDate,
                                size: 15,
                                color: AppColors.greyTextColor,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  CommonDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonText.regular(
                            CourseApprovalsDetailStrings.quizLeaderBoardPosition,
                            size: 17,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        CommonText.regular(
                          '#${data.rankPosition}',
                          size: 17,
                          color: isDarkMode
                              ? AppColors.bodyTextDarkColor
                              : AppColors.bodyTextColor,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }


}
