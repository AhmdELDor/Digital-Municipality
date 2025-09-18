import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/input_field/common_text_field.dart';
import '../../../common_widgets/view_common_widget/common_circle_add_button.dart';
import '../../../common_widgets/view_common_widget/common_delete_view.dart';
import '../../../common_widgets/widgets/text.dart';
import '../../../common_widgets/widgets/validations.dart';
import '../controller/add_course_controller.dart';
import 'basic_information_view.dart';

class ExtraInformationView extends StatefulWidget {
  const ExtraInformationView({super.key});

  @override
  State<ExtraInformationView> createState() => _ExtraInformationViewState();
}

class _ExtraInformationViewState extends State<ExtraInformationView> {
  AddCourseController controller = Get.put(AddCourseController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: mobileView
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: commonAddButtonView(
                          '1.${CourseApprovalsDetailStrings.learningOutcomes}',
                        ),
                      ),

                      CommonDivider(height: 2),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: learningOutCome(),
                      ),
                      Gap(15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: learningOutComeTwo(),
                      ),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: learningOutComeThree(),
                      ),
                      Gap(15),
                    ],
                  ),
                ),
                Gap(25),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: commonAddButtonView(
                          '2.${CourseApprovalsDetailStrings.features}',
                        ),
                      ),
                      CommonDivider(height: 2),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: featureImageOneView(),
                      ),
                      Gap(15),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: featureOneView(),
                      ),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: featureImageTwoView(),
                      ),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: featureTwoView(),
                      ),
                      Gap(15),
                    ],
                  ),
                ),
                Gap(25),
                Container(
                  decoration: BoxDecoration(
                    color: isDarkMode
                        ? AppColors.mainDarkBgColor
                        : AppColors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDarkMode
                          ? AppColors.grey100Color
                          : AppColors.lightBorderColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 15,
                          vertical: 12,
                        ),
                        child: commonAddButtonView(
                          '3.${CourseApprovalsDetailStrings.requirements}',
                        ),
                      ),
                      CommonDivider(height: 2),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CommonText.medium(
                              AddCoursesStrings.enterRequirements,
                              size: 15,
                            ),
                            CommonDeleteView(),
                          ],
                        ),
                      ),
                      Gap(15),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: CommonTextField(
                          hintText: AddCoursesStrings.enterRequirementsHint,
                          controller: controller.requirementsController,
                          textInputAction: TextInputAction.next,
                          validator: (value) {
                            return validateEmptyValue(
                              value,
                              'This Filed is Required',
                            );
                          },
                          maxLines: 4,
                        ),
                      ),

                      Gap(15),
                    ],
                  ),
                ),
              ],
            )
          : desktopView(),
    );
  }

  Widget desktopView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey100Color
              : AppColors.lightBorderColor,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: commonAddButtonView(
              '1.${CourseApprovalsDetailStrings.learningOutcomes}',
            ),
          ),

          CommonDivider(height: 2),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: learningOutCome()),
                Gap(25),
                Expanded(child: learningOutComeTwo()),
              ],
            ),
          ),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: learningOutComeThree()),
                Gap(25),
                Expanded(child: learningOutComeFour()),
              ],
            ),
          ),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: commonAddButtonView(
              '2.${CourseApprovalsDetailStrings.features}',
            ),
          ),
          CommonDivider(height: 2),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: featureImageOneView()),
                Gap(25),
                Expanded(child: featureOneView()),
              ],
            ),
          ),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(child: featureImageTwoView()),
                Gap(25),
                Expanded(child: featureTwoView()),
              ],
            ),
          ),
          Gap(25),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: commonAddButtonView(
              '3.${CourseApprovalsDetailStrings.requirements}',
            ),
          ),
          CommonDivider(height: 2),
          Gap(25),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            child: CommonText.medium(
              AddCoursesStrings.enterRequirements,
              size: 15,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    hintText: AddCoursesStrings.enterRequirementsHint,
                    controller: controller.requirementsController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return validateEmptyValue(
                        value,
                        'This Filed is Required',
                      );

                    },
                    maxLines: 4,
                  ),
                ),
                Gap(25),
                CommonDeleteView(),
              ],
            ),
          ),
          Gap(25),
        ],
      ),
    );
  }

  Widget commonHeaderText(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CommonText.medium(title, size: 15),
        CommonDeleteView()
      ],
    );
  }

  Widget learningOutCome() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeaderText(AddCoursesStrings.learningOutcomeOne),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.learningOutcomeOneHint,
          controller: controller.outComeOneController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Filed is Required');
          },
        ),
      ],
    );
  }

  Widget learningOutComeTwo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeaderText(AddCoursesStrings.learningOutcomeTwo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.learningOutcomeOneHint,
          controller: controller.secondOutComeOneController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Filed is Required');
          },
        ),
      ],
    );
  }

  Widget learningOutComeThree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeaderText(AddCoursesStrings.learningOutcomeThree),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.learningOutcomeOneHint,
          controller: controller.threeOutComeOneController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Filed is Required');
          },
        ),
      ],
    );
  }

  Widget learningOutComeFour() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeaderText(AddCoursesStrings.learningOutcomeFour),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.learningOutcomeOneHint,
          controller: controller.fourOutComeOneController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Filed is Required');
          },
        ),
      ],
    );
  }

  Widget featureImageOneView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonRequiredHeaderText(AddCoursesStrings.image),
            mobileView?CommonDeleteView():SizedBox(),
          ],
        ),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.featureImageController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.featureImageController);
              },
              child: Container(
                width: 73,
                height: 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.greyDarkColor
                      : AppColors.lightBorderColor.withValues(alpha: 0.40),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CommonText.medium(
                    AddCoursesStrings.chooseFile,
                    size: 12,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget featureImageTwoView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonRequiredHeaderText(AddCoursesStrings.imageTwo),
            mobileView?CommonDeleteView():SizedBox(),
          ],
        ),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.featureImageTwoController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.featureImageTwoController);
              },
              child: Container(
                width: 73,
                height: 25,
                decoration: BoxDecoration(
                  color: isDarkMode
                      ? AppColors.greyDarkColor
                      : AppColors.lightBorderColor.withValues(alpha: 0.40),
                  border: Border.all(
                    color: isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.lightBorderColor,
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Center(
                  child: CommonText.medium(
                    AddCoursesStrings.chooseFile,
                    size: 12,
                    color: isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget featureOneView() {
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.featureOne),
        Gap(10),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                hintText: AddCoursesStrings.enterFeatureDescription,
                controller: controller.outComeOneController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return validateEmptyValue(value, 'This Filed is Required');
                },
              ),
            ),
            Gap(mobileView?0:25),
            mobileView?SizedBox():CommonDeleteView(),
          ],
        ),
      ],
    );
  }

  Widget featureTwoView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.featureTwo),
        Gap(10),
        Row(
          children: [
            Expanded(
              child: CommonTextField(
                hintText: AddCoursesStrings.enterFeatureDescription,
                controller: controller.outComeOneController,
                textInputAction: TextInputAction.next,
                validator: (value) {
                  return validateEmptyValue(value, 'This Filed is Required');
                },
              ),
            ),
            Gap(25),
            CommonDeleteView(),
          ],
        ),
      ],
    );
  }
}

Widget commonAddButtonView(String title,) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      CommonText.regular(
        title,
        size: 17,
        color: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
      ),
      CommonCircleAddButton()
    ],
  );
}
