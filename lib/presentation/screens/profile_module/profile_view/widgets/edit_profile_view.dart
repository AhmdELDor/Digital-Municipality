import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/profile_view_controller.dart';

class EditProfileView extends StatefulWidget {
  const EditProfileView({super.key});

  @override
  State<EditProfileView> createState() => _EditProfileViewState();
}

class _EditProfileViewState extends State<EditProfileView> {
  ProfileViewController controller = Get.put(ProfileViewController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CommonText.semiBold(ProfileViewStrings.editProfile, size: 18),
              commonCloseIcon(context),
            ],
          ),
        ),
        CommonDivider(),
        Gap(20),
        SizedBox(
          height: context.height * 0.5,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: controller.formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    commonHeader(ProfileViewStrings.name),
                    Gap(10),
                    CommonTextField(
                      hintText: ProfileViewStrings.name,
                      controller: controller.nameController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return validateEmptyValue(value, 'Name is Required');
                      },
                    ),
                    Gap(20),

                    commonHeader(ProfileViewStrings.role),
                    Gap(10),
                    Obx(
                      () => AlwaysDownDropdown<String>(
                        color: Colors.transparent,
                        hintText: "Select",
                        items: controller.roleList,
                        value: controller.selectedRole.value,
                        onChanged: (val) {
                          controller.selectedRole.value = val!;
                        },

                       //validator: (val) => val == null ? "Select" : null,
                      ),
                    ),
                    Gap(20),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonHeader(ProfileViewStrings.country),
                              Gap(10),
                              Obx(
                                () => AlwaysDownDropdown<String>(color: Colors.transparent,
                                  hintText: "Select",
                                  items: controller.countryList,
                                  value: controller.selectedCountry.value,
                                  onChanged: (val) {
                                    controller.selectedCountry.value = val!;
                                  },

                                  // validator: (val) =>
                                  //     val == null ? "Select" : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Gap(20),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              commonHeader(ProfileViewStrings.city),
                              Gap(10),
                              Obx(
                                () => AlwaysDownDropdown<String>(color: Colors.transparent,
                                  hintText: "Select",
                                  items: controller.cityList,
                                  value: controller.selectedCity.value,
                                  onChanged: (val) {
                                    controller.selectedCity.value = val!;
                                  },

                                  // validator: (val) =>
                                  //     val == null ? "Select" : null,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(20),

                    commonHeader(ProfileViewStrings.image),
                    Gap(10),
                    CommonTextField(
                      hintText: AddCoursesStrings.select,
                      controller: controller.imageAController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return validateEmptyValue(
                          value,
                          'This Field is Required',
                        );
                      },
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            controller.pickFileCommon(
                              controller.imageAController,
                            );
                          },
                          child: Container(
                            width: 73,
                            height: 25,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.greyDarkColor
                                  : AppColors.lightBorderColor.withValues(
                                      alpha: 0.40,
                                    ),
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

                    Gap(20),

                    commonHeader(ProfileViewStrings.backgroundImage),
                    Gap(10),
                    CommonTextField(
                      hintText: AddCoursesStrings.select,
                      controller: controller.backgroundImageAController,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        return validateEmptyValue(
                          value,
                          'This Field is Required',
                        );
                      },
                      suffixIcon: Padding(
                        padding: const EdgeInsets.only(right: 12),
                        child: InkWell(
                          onTap: () {
                            controller.pickFileCommon(
                              controller.backgroundImageAController,
                            );
                          },
                          child: Container(
                            width: 73,
                            height: 25,
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? AppColors.greyDarkColor
                                  : AppColors.lightBorderColor.withValues(
                                      alpha: 0.40,
                                    ),
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
                ),
              ),
            ),
          ),
        ),
        Gap(25),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          child: Row(
            children: [
              Expanded(
                child: OutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: AppCommonStrings.btnCancel,
                  borderSide: BorderSide(color: AppColors.primary500),
                  textColor: AppColors.primary500,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
              Gap(15),
              Expanded(
                child: PrimaryButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  label: UserManagementStrings.update,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),


      ],
    );
  }
}
