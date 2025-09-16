import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../utils/extensions/responsive.dart';
import '../../../app/theme_controller.dart';
import '../../../common_widgets/input_field/common_text_field.dart';
import '../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../common_widgets/widgets/button.dart';
import '../../../common_widgets/widgets/common_divider.dart';
import '../../../common_widgets/widgets/validations.dart';
import '../controller/add_course_controller.dart';
import 'basic_information_view.dart';
import 'extra_information_view.dart';

class CourseCurriculumView extends StatefulWidget {
  const CourseCurriculumView({super.key});

  @override
  State<CourseCurriculumView> createState() => _CourseCurriculumViewState();
}

class _CourseCurriculumViewState extends State<CourseCurriculumView> {
  AddCourseController controller = Get.put(AddCourseController());
  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return SingleChildScrollView(
      child: mobileView ? mobileDetailView() : desktopView(),
    );
  }

  Widget mobileDetailView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      children: [
        Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: commonAddButtonView(
                  CourseApprovalsDetailStrings.sessionDetails,
                ),
              ),
              CommonDivider(height: 2),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: sessionNoView(controller.sessionNoOneController),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: sessionTitleView(controller.sessionNoOneTitleController),
              ),
              Gap(15),
              CommonDivider(height: 2),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: sessionNoView(controller.sessionNoTwoController),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: sessionTitleView(controller.sessionNoTwoTitleController),
              ),
              Gap(15),
            ],
          ),
        ),
        Gap(25),
        Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 12,
                ),
                child: commonAddButtonView(DashboardViewStrings.lectureDetail),
              ),
              CommonDivider(height: 2),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: selectSessionView(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: srView(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: timeOfLecture(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: durationOfVideo(),
              ),
              Gap(15),
              CommonDivider(height: 2),
              Gap(15),
              //2 session
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: selectSessionView(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: srView(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: timeOfLecture(),
              ),
              Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: durationOfVideo(),
              ),
              Gap(15),
            ],
          ),
        ),
      ],
    );
  }

  Widget desktopView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: commonAddButtonView(
                  CourseApprovalsDetailStrings.sessionDetails,
                ),
              ),
              CommonDivider(height: 2),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: sessionNoView(controller.sessionNoOneController),
                    ),

                    Gap(25),
                    Expanded(
                      child: sessionTitleView(
                        controller.sessionNoOneTitleController,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(
                      child: sessionNoView(controller.sessionNoTwoController),
                    ),
                    Gap(25),
                    Expanded(
                      child: sessionTitleView(
                        controller.sessionNoTwoTitleController,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: PrimaryButton(
                        height: 42,
                        onPressed: () {},
                        borderRadius: 9,
                        label: AppCommonStrings.btnCancel,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        backgroundColor: isDarkMode
                            ? AppColors.mainDarkBgColor
                            : AppColors.lightBgColor,
                        borderSide: BorderSide(
                          color: AppColors.primary500,
                          width: 1,
                        ),
                        textColor: AppColors.primary500,
                      ),
                    ),
                    Gap(25),
                    SizedBox(
                      width: 160,
                      child: PrimaryButton(
                        height: 42,
                        onPressed: () {},
                        label: AppCommonStrings.btnSave,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(25),
            ],
          ),
        ),
        Gap(25),
        Container(
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 15,
                ),
                child: commonAddButtonView(DashboardViewStrings.lectureDetail),
              ),
              CommonDivider(height: 2),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(child: selectSessionView()),
                    Gap(25),
                    Expanded(child: srView()),
                  ],
                ),
              ),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    Expanded(child: timeOfLecture()),
                    Gap(25),
                    Expanded(child: durationOfVideo()),
                  ],
                ),
              ),
              Gap(25),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  children: [
                    SizedBox(
                      width: 160,
                      child: PrimaryButton(
                        height: 42,
                        onPressed: () {},
                        label: AddCoursesStrings.previous,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        backgroundColor: isDarkMode
                            ? AppColors.mainDarkBgColor
                            : AppColors.lightBgColor,
                        borderSide: BorderSide(
                          color: AppColors.primary500,
                          width: 1,
                        ),
                        textColor: AppColors.primary500,
                        borderRadius: 9,
                      ),
                    ),
                    Gap(25),
                    SizedBox(
                      width: 160,
                      child: PrimaryButton(
                        height: 42,
                        onPressed: () {},
                        label: AddCoursesStrings.addCourse,
                        textSize: 16,
                        textWeight: FontWeight.w500,
                        borderRadius: 9,
                      ),
                    ),
                  ],
                ),
              ),
              Gap(25),
            ],
          ),
        ),
      ],
    );
  }

  Widget sessionNoView(TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            commonRequiredHeaderText(AddCoursesStrings.sessionNo),
           // SvgImageFromAsset(AppCommonIcon.deleteIcon),
          ],
        ),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterSessionNo,
          controller: textController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Course name is Required');
          },
        ),
      ],
    );
  }

  Widget sessionTitleView(TextEditingController textController) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.sessionTitle),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterSessionTitle,
          controller: textController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Course name is Required');
          },
        ),
      ],
    );
  }

  Widget selectSessionView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.session),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: "Select",
            items: controller.sessionList,
            value: controller.selectedSession.value.isEmpty
                ? null
                : controller.selectedSession.value,
            onChanged: (val) {
              controller.selectedSession.value = val ?? '';
            },
            // validator: (val) =>
            //     val == null || val.isEmpty ? "Select session" : null,
          ),
        ),
      ],
    );
  }

  Widget srView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.srNo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.sessions,
          controller: controller.srNoController,
          textInputAction: TextInputAction.next,
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
                        int.tryParse(controller.srNoController.text) ?? 0;
                    current++;
                    controller.srNoController.text = current.toString();
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
                        int.tryParse(controller.srNoController.text) ?? 0;
                    if (current > 0) {
                      current--; // don’t go below 0
                    }
                    controller.srNoController.text = current.toString();
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

  Widget timeOfLecture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.titleOfLecture),
        Gap(10),
        CommonTextField(
          hintText: AddNoteStrings.enterTitle,
          controller: controller.timeOfLectureController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Title is Required');
          },
        ),
      ],
    );
  }

  Widget durationOfVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.durationOfVideo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterDuration,
          controller: controller.durationOfController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Duration is Required');
          },
        ),
      ],
    );
  }

  //2 session
  Widget selectSessionSecondView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.session),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<String>(
            hintText: "Select",
            items: controller.secondSessionList,
            value: controller.selectedSecondSession.value.isEmpty
                ? null
                : controller.selectedSecondSession.value,
            onChanged: (val) {
              controller.selectedSecondSession.value = val ?? '';
            },
            // validator: (val) =>
            //     val == null || val.isEmpty ? "Select session" : null,
          ),
        ),
      ],
    );
  }

  Widget srSecondView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.srNo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.sessions,
          controller: controller.srNoSecondController,
          textInputAction: TextInputAction.next,
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
                        int.tryParse(controller.srNoSecondController.text) ?? 0;
                    current++;
                    controller.srNoSecondController.text = current.toString();
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
                        int.tryParse(controller.srNoSecondController.text) ?? 0;
                    if (current > 0) {
                      current--; // don’t go below 0
                    }
                    controller.srNoSecondController.text = current.toString();
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

  Widget timeOfSecondLecture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.titleOfLecture),
        Gap(10),
        CommonTextField(
          hintText: AddNoteStrings.enterTitle,
          controller: controller.timeOfLectureSecondController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Title is Required');
          },
        ),
      ],
    );
  }

  Widget durationOfSecondVideo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonRequiredHeaderText(AddCoursesStrings.durationOfVideo),
        Gap(10),
        CommonTextField(
          hintText: AddCoursesStrings.enterDuration,
          controller: controller.durationOfSecondController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Duration is Required');
          },
        ),
      ],
    );
  }
}
