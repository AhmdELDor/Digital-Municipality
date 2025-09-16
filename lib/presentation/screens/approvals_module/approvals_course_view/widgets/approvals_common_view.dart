import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/view_common_widget/common_card_decoration.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../controller/approvals_course_view_controller.dart';

Widget customTabWithBadge(
    String label,
    int count, {
      required bool isSelected,
    }) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 10),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CommonText.semiBold(
          label,
          size: 16,
          color: isSelected ? AppColors.primary500 : AppColors.bodyTextColor,
          fontWeight: isSelected?FontWeight.w500:FontWeight.w400,
        ),
        Gap(8),
        Container(
          height: 20,
          width: 20,
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary500 : AppColors.bodyTextColor,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: CommonText.semiBold(
              count.toString(),
              color: AppColors.white,
              size: 12,
            ),
          ),
        ),
      ],
    ),
  );
}

Widget filterView(void Function()? onTap,String length){
  return InkWell(
    onTap: onTap,
    child: Container(
      width: 51,
      height: 32,
      decoration: commonCardDecoration(5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgImageFromAsset(AppCommonIcon.filterIcon),
          Gap(5),
          Container(
            height: 15,
            width: 15,
            decoration: BoxDecoration(
              color: AppColors.primary500,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: CommonText.semiBold(
                length,
                color: AppColors.white,
                size: 9,
              ),
            ),
          ),
        ],
      ),
    ),
  );
}


//approval Drop down
Widget usersDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
    () =>  AlwaysDownDropdown<String>(
      hintText: "Select",
      items: controller.usersList,
      value: controller.selectedUser.value.isEmpty
          ? null
          : controller.selectedUser.value,
      onChanged: (val) {
        controller.selectedUser.value = val ?? '';
      },
      // validator: (val) => val == null || val.isEmpty
      //     ? "Please select"
      //     : null,
    ),
  );
}
Widget courseCategoryDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
    () =>  AlwaysDownDropdown<String>(
      hintText: "Category",
      items:
      controller.data.value.courseCategoryList,
      value:
      controller
          .selectedCourseCategory
          .value
          .isEmpty
          ? null
          : controller.selectedCourseCategory.value,
      onChanged: (val) {
        controller.selectedCourseCategory.value =
            val ?? '';
      },
      // validator: (val) => val == null || val.isEmpty
      //     ? "Category"
      //     : null,
    ),
  );
}

Widget languageDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
    () =>  AlwaysDownDropdown<String>(
      hintText: "Language",
      items: controller.data.value.languageList,
      value:
      controller.selectedLanguage.value.isEmpty
          ? null
          : controller.selectedLanguage.value,
      onChanged: (val) {
        controller.selectedLanguage.value =
            val ?? '';
      },
      // validator: (val) => val == null || val.isEmpty
      //     ? "Language"
      //     : null,
    ),
  );
}

Widget priceRangeDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return  Obx(
    () =>  AlwaysDownDropdown<double>(
      hintText: "Price Range",
      items: controller.data.value.priceRangeList,
      value: controller.selectedPrice.value == 0.0
          ? null
          : controller.selectedPrice.value,
      onChanged: (val) {
        controller.selectedPrice.value = val ?? 0.0;
      },
     // validator: (val) => val == null ? "Price Range" : null,
    ),
  );
}

Widget customDatePicker(TextEditingController? dateController){
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return CommonDatePicker(
    hintText: ApprovalsStrings.requestDate,
    controller: dateController,
    suffixIcon: SvgImageFromAsset(
      AppCommonIcon.calenderIcon,
      height: 16,
      width: 16,
      colorFilter: ColorFilter.mode(isDarkMode
          ? AppColors.bodyTextDarkColor
          : AppColors.bodyTextColor, BlendMode.srcIn),
    ),
    onDatePicked: (date) {},
  );
}


//instructor Drop Down
Widget instructorUsersDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
        () =>  AlwaysDownDropdown<String>(
          hintText: "Select",
          items: controller.usersList,
          value: controller.selectedInstructorUser.value.isEmpty
              ? null
              : controller.selectedInstructorUser.value,
          onChanged: (val) {
            controller.selectedInstructorUser.value = val ?? '';
          },
          //validator: (val) => val == null || val.isEmpty ? "Please select" : null,
        ),
  );
}
Widget identityProofTypeDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
        () =>  AlwaysDownDropdown<String>(
          hintText: "Identity Proof Type",
          items: controller.data.value.identityProofList,
          value: controller.identityProofType.value.isEmpty
              ? null
              : controller.identityProofType.value,
          onChanged: (val) {
            controller.identityProofType.value = val ?? '';
          },
          // validator: (val) => val == null || val.isEmpty
          //     ? "Identity Proof Type"
          //     : null,
        ),
  );
}
Widget qualificationProofTypeDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
        () => AlwaysDownDropdown<String>(
          hintText: "Qualification Proof Type",
          items: controller.data.value.identityProofList,
          value: controller.qualificationProofType.value.isEmpty
              ? null
              : controller.qualificationProofType.value,
          onChanged: (val) {
            controller.qualificationProofType.value = val ?? '';
          },
          // validator: (val) => val == null || val.isEmpty
          //     ? "Qualification Proof Type"
          //     : null,
        ),
  );
}

//university Drop Down
Widget registrationProofTypeDropDown(){
  ApprovalsViewController controller = Get.put(ApprovalsViewController());
  return Obx(
        () => AlwaysDownDropdown<String>(
          hintText: "Registration Proof Type",
          items: controller.data.value.registrationProofList,
          value: controller.registrationProofType.value.isEmpty
              ? null
              : controller.registrationProofType.value,
          onChanged: (val) {
            controller.registrationProofType.value = val ?? '';
          },
          // validator: (val) => val == null || val.isEmpty
          //     ? "Registration Proof Type"
          //     : null,
        ),
  );
}



