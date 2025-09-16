import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../../../add_course_module/widgets/basic_information_view.dart';
import '../controller/add_class_controller.dart';

Widget classNameView() { AddClassController controller = Get.put(AddClassController());
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonRequiredHeaderText(AddCoursesStrings.name),
      Gap(10),
      CommonTextField(
        hintText: AddNoteStrings.enterTitle,
        controller: controller.classNameController,
        textInputAction: TextInputAction.next,
        validator: (value) {
          return validateEmptyValue(value, 'Class name is Required');
        },
      ),
    ],
  );
}
Widget selectCourseView() { AddClassController controller = Get.put(AddClassController());
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonRequiredHeaderText(AddClassStrings.course),
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
         // validator: (val) => val == null || val.isEmpty ? "Select" : null,
        ),
      ),
    ],
  );
}
Widget selectDate() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode; AddClassController controller = Get.put(AddClassController());
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonRequiredHeaderText(AddClassStrings.date),
      Gap(10),
      CommonClassDatePicker(
        hintText: AddClassStrings.selectDate,
        controller: controller.dateController,
        suffixIcon: SvgImageFromAsset(
          AppCommonIcon.calenderIcon,
          height: 16,
          width: 16,
          colorFilter: ColorFilter.mode(
            isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            BlendMode.srcIn,
          ),
        ),
        onDatePicked: (date) {},
      ),
    ],
  );
}
Widget selectTime(BuildContext context) {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode; AddClassController controller = Get.put(AddClassController());
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonRequiredHeaderText(AddClassStrings.time),
      Gap(10),
      CommonTextField(
        hintText: AddClassStrings.enterTime,
        controller: controller.timeController,
        onTap: () {
          controller.pickTime(context);
        },
        suffixIcon: Padding(
          padding: const EdgeInsets.only(right: 12),
          child: SvgImageFromAsset(
            AppCommonIcon.clockIcon,
            height: 16,
            width: 16,
            colorFilter: ColorFilter.mode(
              isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
    ],
  );
}
Widget imageVideoView() {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode; AddClassController controller = Get.put(AddClassController());
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
Widget selectInstructorView() { AddClassController controller = Get.put(AddClassController());
  return Column(
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
         // validator: (val) => val == null || val.isEmpty ? "Select instructor" : null,
        ),
      ),
    ],
  );
}
Widget descriptionController(BuildContext context) {
  AddClassController controller = Get.put(AddClassController());
  var mobileView = ResponsiveView.isMobile(context);
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonRequiredHeaderText(AddCoursesStrings.description),
      Gap(10),
      CommonTextField(
        hintText: AddCoursesStrings.enterDescription,
        controller: controller.descriptionController,
        maxLines:mobileView?3:1 ,
      ),
    ],
  );
}