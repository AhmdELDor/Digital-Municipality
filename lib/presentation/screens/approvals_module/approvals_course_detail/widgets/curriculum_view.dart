import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../controller/approvals_course_detail_controller.dart';

class CurriculumView extends StatefulWidget {
  const CurriculumView({super.key});

  @override
  State<CurriculumView> createState() => _CurriculumViewState();
}

class _CurriculumViewState extends State<CurriculumView> {
  CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: controller.data.value.courseCurriculumList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        itemBuilder: (context, index) {
          final data = controller.data.value.courseCurriculumList[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Theme(
              data: ThemeData(dividerColor: Colors.transparent),
              child: Container(
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.cardDarkBgColor
                      : AppColors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: ExpansionTile(
                  collapsedIconColor: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
                  iconColor: isDarkMode
                      ? AppColors.bodyTextDarkColor
                      : AppColors.bodyTextColor,
      
                  title: Row(
                    children: [
                      Expanded(
                        child: CommonText.regular(
                          data.title,
                          size: 17,
                          // color: isDarkMode
                          //     ? AppColors.headingsLightColor
                          //     : AppColors.primary500,
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                      ),
                      mobileView?SizedBox(): Gap(10),
                      mobileView?SizedBox():Container(
                        height: 43,
                        width: 1,
                        color: isDarkMode?AppColors.grey100Color:AppColors.headingsLightColor,
                      ),
                      mobileView?SizedBox():  Gap(10),
                      mobileView?SizedBox(): CommonText.regular(
                        '(0${data.lecturesList.length} Lectures)',
                        size: 17,

                      ),
                    ],
                  ),
      
                  children: [
                    Container(
                      color: isDarkMode
                          ? AppColors.mainDarkBgColor
                          : AppColors.white,
                      child: ListView.builder(
                        itemCount: data.lecturesList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
      
                        itemBuilder: (context, index) {
                          final lecture = data.lecturesList[index];
                          return Padding(
                            padding: const EdgeInsets.all(15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                CommonText.medium(
                                  '0${lecture.id.toString()}',
                                  size: 16,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                ),
                                Gap(12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      CommonText.medium(
                                        lecture.name,
                                        size: 14,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      CommonText.regular(
                                        lecture.timeOfVideo,
                                        size: 13,
                                        color: isDarkMode
                                            ? AppColors.greyTextDarkColor
                                            : AppColors.greyTextColor,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
