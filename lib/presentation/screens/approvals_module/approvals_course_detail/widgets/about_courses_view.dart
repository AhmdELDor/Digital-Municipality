import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_cache_image.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../controller/approvals_course_detail_controller.dart';

class AboutCoursesView extends StatefulWidget {
  const AboutCoursesView({super.key});

  @override
  State<AboutCoursesView> createState() => _AboutCoursesViewState();
}
class _AboutCoursesViewState extends State<AboutCoursesView> {
  final CourseApprovalsDetailController controller = Get.put(CourseApprovalsDetailController());

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    bool mobileView = ResponsiveView.isMobile(context);

    return Obx(() {
      return SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top section (different for mobile and desktop)
            mobileView ? _mobileTopView() : _desktopTopView(),

            Gap(15),
            _cardSection(
              title: CourseApprovalsDetailStrings.descriptionOfCourse,
              child: CommonText.regular(
                controller.data.value.description,
                size: 15,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
            ),

            Gap(15),
            _cardSection(
              title: CourseApprovalsDetailStrings.learningOutcomes,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: controller.data.value.learningOutComesList.map((item) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: CommonText.regular(
                      item,
                      size: 15,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                  );
                }).toList(),
              ),
            ),

            Gap(15),
            _cardSection(
              title: CourseApprovalsDetailStrings.requirements,
              child: CommonText.regular(
                controller.data.value.requirements,
                size: 15,
                color: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
              ),
            ),


          ],
        ),
      );
    });
  }

  Widget _mobileTopView() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 6,
              child: _commonHeaderView(
                DashboardViewStrings.category,
                controller.data.value.courseCategory,
              ),
            ),
            Gap(20),
            Expanded(
              flex: 6,
              child: _commonHeaderView(
                CourseApprovalsDetailStrings.courseType,
                controller.data.value.courseType,
              ),
            ),
          ],
        ),
        Gap(15),
        Row(
          children: [
            Expanded(
              flex: 6,
              child: _commonHeaderView(
                CourseApprovalsDetailStrings.language,
                controller.data.value.language,
              ),
            ),
            Gap(20),
            Expanded(
              flex: 6,
              child: _commonHeaderView(
                CourseApprovalsDetailStrings.assessmentTest,
                'Illustrator Test',
              ),
            ),
          ],
        ),
        Gap(15),
        _instructorView(),
        Gap(15),
        courseFeaturesView()
      ],
    );
  }

  Widget _desktopTopView() {
    return Row(
      children: [
        Expanded(
          flex: 1,
          child: _commonHeaderView(
            DashboardViewStrings.category,
            controller.data.value.courseCategory,
          ),
        ),
        Gap(20),
        Expanded(
          flex: 2,
          child: _commonHeaderView(
            CourseApprovalsDetailStrings.courseType,
            controller.data.value.courseType,
          ),
        ),
        Gap(20),
        Expanded(
          flex: 2,
          child: _commonHeaderView(
            CourseApprovalsDetailStrings.language,
            controller.data.value.language,
          ),
        ),
        Gap(20),
        Expanded(
          flex: 2,
          child: _commonHeaderView(
            CourseApprovalsDetailStrings.assessmentTest,
            'Illustrator Test',
          ),
        ),
        Gap(20),
        Expanded(flex: 2, child: _instructorView()),
      ],
    );
  }

  Widget _cardSection({required String title, required Widget child}) {
    return Container(
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _commonHeaderContainer(title),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            child: child,
          ),
        ],
      ),
    );
  }

  Widget courseFeaturesView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
        border: Border.all(
          color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText.medium(CourseApprovalsDetailStrings.features, size: 17),
          Gap(15),
          Column(
            children: controller.data.value.courseFeatureList.map((data) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Row(
                  children: [
                    commonCacheImage(
                      data.image,
                      ImagePlaceHolder.imagePlaceHolderDark,
                      height: 20,
                      width: 20,
                      fit: BoxFit.fill,
                    ),
                    Gap(12),
                    CommonText.regular(
                      data.name,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
  _commonHeaderView(String title, subtitle) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: 62,
      width: double.infinity,
      decoration: commonCardDecoration(9),

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CommonText.regular(title, size: 15,color:isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,),
            Gap(5),
            CommonText.regular(subtitle, size: 15,overflow: TextOverflow.ellipsis,maxLines: 1,),
          ],
        ),
      ),
    );
  }
  _commonHeaderContainer(String title) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      height: 50,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.cardDarkBgColor : AppColors.lightBgColor,
        border: Border(
          bottom: BorderSide(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: CommonText.medium(title, size: 17),
    );
  }
  _cardDecoration() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return BoxDecoration(
      color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
      border: Border.all(
        color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
        width: 1,
      ),
      borderRadius: BorderRadius.circular(16),
    );
  }
  _instructorView() {
    return Container(
      decoration: commonCardDecoration(9),
      //margin:  EdgeInsetsGeometry.only(top: 15,right: 15),
      padding: EdgeInsets.symmetric(horizontal: 10),
      height: 62,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(36),
            child: commonCacheImage(
              controller.data.value.instructorProfileImg,
              ImagePlaceHolder.imagePlaceHolderDark,
              height: 36,
              width: 36,
            ),
          ),
          Gap(10),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CommonText.regular(
                    CourseApprovalsDetailStrings.instructor,
                    size: 15,
                  ),
                  Gap(5),
                  CommonText.regular(
                    controller.data.value.instructorName,
                    size: 17,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}





courseFeaturesView() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  CourseApprovalsDetailController controller = Get.put(
    CourseApprovalsDetailController(),
  );
  return Obx(
    () =>  Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
        border: Border.all(
          color: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          CommonText.medium(CourseApprovalsDetailStrings.features, size: 17),
          Gap(15),
          ListView.separated(
            itemCount: controller.data.value.courseFeatureList.length,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final data = controller.data.value.courseFeatureList[index];
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    commonCacheImage(
                      data.image,
                      ImagePlaceHolder.imagePlaceHolderDark,
                      height: 20,
                      width: 20,
                      //fit: BoxFit.fill
                    ),
                    Gap(12),
                    CommonText.regular(
                      data.name,
                      size: 16,
                      color: isDarkMode
                          ? AppColors.bodyTextDarkColor
                          : AppColors.bodyTextColor,
                    ),
                  ],
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: CommonDivider(),
              );
            },
          ),
        ],
      ),
    ),
  );
}
