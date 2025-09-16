import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_email_field.dart';
import '../../../../common_widgets/input_field/common_mobile_field.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/user_management_controller.dart';

class AddUserView extends StatefulWidget {
  const AddUserView({super.key});

  @override
  State<AddUserView> createState() => _AddUserViewState();
}

class _AddUserViewState extends State<AddUserView> {
  UserManagementController controller = Get.put(UserManagementController());
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;

    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: 20,
                        horizontal: 20,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText.semiBold(
                            UserManagementStrings.addUser,
                            size: 18,
                          ),
                          commonCloseIcon(context),
                        ],
                      ),
                    ),

                    CommonDivider(),
                    Gap(25),

                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          commonHeader(UserManagementStrings.name),
                          Gap(10),
                          CommonTextField(
                            labelText: UserManagementStrings.enterName,
                            controller: controller.nameController,
                            textInputAction: TextInputAction.next,
                            hintText: UserManagementStrings.enterName,
                            validator: (value) {
                              return validateEmptyValue(
                                value,
                                'Name is Required',
                              );
                            },
                          ),

                          Gap(25),
                          commonHeader(UserManagementStrings.role),
                          Gap(10),
                          Obx(
                            () => AlwaysDownDropdown<String>(
                              hintText: "Select",
                              items: controller.roleList,
                              value: controller.selectedRole.value.isEmpty
                                  ? null
                                  : controller.selectedRole.value,
                              onChanged: (val) {
                                controller.selectedRole.value = val ?? '';
                              },
                              //validator: (val) => val == null || val.isEmpty ? "Select" : null,
                            ),
                          ),

                          Gap(25),
                          commonHeader(UserManagementStrings.email),
                          Gap(10),
                          CommonEmailField(
                            labelText: AppCommonStrings.email,
                            autofillHints: const [AutofillHints.email],
                            controller: controller.emailController,
                            textInputAction: TextInputAction.done,
                            hintText: AddInstructorStrings.enterEmail,
                            validator: validateEmail,
                          ),

                          Gap(25),
                          commonHeader(UserManagementStrings.phoneNo),
                          Gap(10),
                          CommonMobileField(
                            hintText: UserManagementStrings.enterMobileNo,
                          ),

                          Gap(25),
                          commonHeader(UserManagementStrings.image),
                          Gap(10),
                          CommonTextField(
                            hintText: AddCoursesStrings.select,
                            controller: controller.imageController,
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
                                    controller.imageController,
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
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 25),
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
                  Gap(20),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () {
                        final isValid = formKey.currentState!.validate();
                        Get.focusScope!.unfocus();

                        if (!isValid) return;

                        formKey.currentState!.save();

                        Navigator.pop(context);
                      },
                      label: UserManagementStrings.addUser,
                      textSize: 16,
                      textWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
