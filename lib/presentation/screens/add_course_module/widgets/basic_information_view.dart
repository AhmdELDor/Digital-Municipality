import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/input_field/common_text_field.dart';
import '../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../common_widgets/widgets/text.dart';
import '../../../common_widgets/widgets/validations.dart';
import '../controller/add_course_controller.dart';

class BasicInformationView extends StatefulWidget {
  const BasicInformationView({super.key});

  @override
  State<BasicInformationView> createState() => _BasicInformationViewState();
}

class _BasicInformationViewState extends State<BasicInformationView> {
  AddCourseController controller = Get.put(AddCourseController());
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: mobileView ? 0 : 15,
          vertical: mobileView ? 0 : 25,
        ),
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: mobileView
                ? Colors.transparent
                : isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
        ),
        child: mobileView ? mobileDetailView() : desktopView(),
      ),
    );
  }

  mobileDetailView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        courseNameView(),
        Gap(15),
        courseCategory(),
        Gap(15),
        priceView(),
        Gap(15),
        imageVideoView(),
        Gap(15),
        courseType(),
        Gap(15),
        languageView(),
        Gap(15),
        Row(
          children: [
            Expanded(child: sessionView()),
            Gap(25),
            Expanded(child: lectureView()),
          ],
        ),
        Gap(15),
        commonRequiredHeaderText(AddCoursesStrings.instructor),
        Gap(15),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: AddCoursesStrings.selectInstructor,
            items: controller.usersList,
            value: controller.selectedUser.value.isEmpty
                ? null
                : controller.selectedUser.value,
            onChanged: (val) {
              controller.selectedUser.value = val ?? '';
            },
            // validator: (val) =>
            //     val == null || val.isEmpty ? "Select instructor" : null,
          ),
        ),
        Gap(15),
        commonRequiredHeaderText(AddCoursesStrings.assessmentTest),
        Gap(15),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: AddCoursesStrings.select,
            items: controller.assessmentTestList,
            value: controller.selectedAssessment.value.isEmpty
                ? null
                : controller.selectedAssessment.value,
            onChanged: (val) {
              controller.selectedAssessment.value = val ?? '';
            },
           // validator: (val) => val == null || val.isEmpty ? AddCoursesStrings.select : null,
          ),
        ),
        Gap(25),

        commonRequiredHeaderText(AddCoursesStrings.description),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterDescription,
          controller: controller.descriptionController,
          maxLines: 3,
        ),
      ],
    );
  }

  desktopView() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: courseNameView()),
            Gap(25),
            Expanded(child: courseCategory()),
          ],
        ),
        Gap(25),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(child: priceView()),
            Gap(25),
            Expanded(child: imageVideoView()),
          ],
        ),
        Gap(25),
        Row(
          children: [
            Expanded(child: courseType()),
            Gap(25),
            Expanded(child: languageView()),
          ],
        ),
        Gap(25),
        Row(
          children: [
            Expanded(child: sessionView()),
            Gap(25),
            Expanded(child: lectureView()),
          ],
        ),
        Gap(25),
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonRequiredHeaderText(AddCoursesStrings.instructor),
                  Gap(10),
                  Obx(
                    () => AlwaysDownDropdown<String>(
                      hintText: AddCoursesStrings.selectInstructor,
                      items: controller.usersList,
                      value: controller.selectedUser.value.isEmpty
                          ? null
                          : controller.selectedUser.value,
                      onChanged: (val) {
                        controller.selectedUser.value = val ?? '';
                      },
                      // validator: (val) => val == null || val.isEmpty
                      //     ? "Select instructor"
                      //     : null,
                    ),
                  ),
                ],
              ),
            ),
            Gap(25),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonRequiredHeaderText(AddCoursesStrings.assessmentTest),
                  Gap(10),
                  Obx(
                    () => AlwaysDownDropdown<String>(
                      hintText: AddCoursesStrings.select,
                      items: controller.assessmentTestList,
                      value: controller.selectedAssessment.value.isEmpty
                          ? null
                          : controller.selectedAssessment.value,
                      onChanged: (val) {
                        controller.selectedAssessment.value = val ?? '';
                      },
                      // validator: (val) => val == null || val.isEmpty
                      //     ? AddCoursesStrings.select
                      //     : null,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        Gap(25),

        commonRequiredHeaderText(AddCoursesStrings.description),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterDescription,
          controller: controller.descriptionController,
          maxLines: 3,
        ),
      ],
    );
  }

  Widget courseNameView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.name),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterCourseName,
          controller: controller.courseNameController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Course name is Required');
          },
        ),
      ],
    );
  }

  Widget courseCategory() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.category),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: "Select",
            items: controller.categoryList,
            value: controller.selectedCategory.value.isEmpty
                ? null
                : controller.selectedCategory.value,
            onChanged: (val) {
              controller.selectedCategory.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget priceView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.price),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterAmount,
          controller: controller.priceController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number,
          inputFormatters: [
            LengthLimitingTextInputFormatter(29),
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: (value) {
            return validateEmptyValue(value, 'Price is Required');
          },
        ),
      ],
    );
  }

  Widget imageVideoView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.imageVideo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.select,
          controller: controller.imageVideoController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 12),
            child: InkWell(
              onTap: () {
                controller.pickFileCommon(controller.imageVideoController);
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

  Widget courseType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.courseType),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: "Select",
            items: controller.categoryList,
            value: controller.selectedCourseType.value.isEmpty
                ? null
                : controller.selectedCourseType.value,
            onChanged: (val) {
              controller.selectedCourseType.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget languageView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.language),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: "Select",
            items: controller.languageList,
            value: controller.selectedLanguage.value.isEmpty
                ? null
                : controller.selectedLanguage.value,
            onChanged: (val) {
              controller.selectedLanguage.value = val ?? '';
            },
            //validator: (val) => val == null || val.isEmpty ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget sessionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.sessions),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.sessions,
          controller: controller.sessionController,
          textInputAction: TextInputAction.next,
          keyboardType: TextInputType.number, // ✅ number input
          validator: (value) {
            return validateEmptyValue(value, 'Session is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    int current =
                        int.tryParse(controller.sessionController.text) ?? 0;
                    current++;
                    controller.sessionController.text = current.toString();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.bodyTextColor,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    int current =
                        int.tryParse(controller.sessionController.text) ?? 0;
                    if (current > 0) {
                      current--; // don’t go below 0
                    }
                    controller.sessionController.text = current.toString();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.bodyTextColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget lectureView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.lectures),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.lectures,
          controller: controller.lectureController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'lectures is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    int current =
                        int.tryParse(controller.lectureController.text) ?? 0;
                    current++;
                    controller.lectureController.text = current.toString();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_up,
                    color: AppColors.bodyTextColor,
                    size: 20,
                  ),
                ),
                InkWell(
                  onTap: () {
                    int current =
                        int.tryParse(controller.lectureController.text) ?? 0;
                    if (current > 0) {
                      current--; // don’t go below 0
                    }
                    controller.lectureController.text = current.toString();
                  },
                  child: const Icon(
                    Icons.keyboard_arrow_down,
                    color: AppColors.bodyTextColor,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Widget commonRequiredHeaderText(String title) {
  return SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.medium(title, size: 15),
        Gap(3),
        CommonText.medium('*', size: 15, color: AppColors.error500),
      ],
    ),
  );
}
