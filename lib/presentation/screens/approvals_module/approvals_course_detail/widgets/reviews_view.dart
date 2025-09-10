import 'package:custom_rating_bar/custom_rating_bar.dart';
import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../controller/approvals_course_detail_controller.dart';

class ReviewsView extends StatefulWidget {
  const ReviewsView({super.key});

  @override
  State<ReviewsView> createState() => _ReviewsViewState();
}

class _ReviewsViewState extends State<ReviewsView> {
  final CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    bool mobileView = ResponsiveView.isMobile(context);
    return ResponsiveGridRow(
      children: List.generate(controller.data.value.reviewList.length, (
          index,
          ) {
        final data = controller.data.value.reviewList[index];
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
                            height: mobileView?44:64,
                            width:mobileView?44: 64,
                          ),
                        ),
                        Gap(12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonText.regular(
                                data.review,
                                size: 15,
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
                  CommonDivider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CommonText.regular(
                           data.name,
                            size: 17,
                            color: isDarkMode
                                ? AppColors.bodyTextDarkColor
                                : AppColors.bodyTextColor,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),

                        ),
                        RatingBar.readOnly(
                          size: 20,
                          filledIcon: Icons.star,
                          emptyIcon: Icons.star_border,
                          initialRating: data.rate.toDouble(),
                          alignment: Alignment.center,

                          filledColor: AppColors.secondary500,
                          emptyColor: AppColors.greyTextColor,
                          maxRating: 5,


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
