import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_mobile_field.dart';
import '../../../../common_widgets/input_field/common_password_field.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/user_management_controller.dart';
import '../model/users_model.dart';

class EditUserView extends StatefulWidget {
  final UsersModel user;
  
  const EditUserView({super.key, required this.user});

  @override
  State<EditUserView> createState() => _EditUserViewState();
}

class _EditUserViewState extends State<EditUserView> {
  late UserManagementController controller;
  final formKey = GlobalKey<FormState>();
  
  @override
  void initState() {
    super.initState();
    controller = Get.find<UserManagementController>();
    // Load user data for editing
    controller.loadUserForEdit(widget.user);
  }

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
                            'تعديل المستخدم',
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
                          // Full Name
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
                                'الاسم مطلوب',
                              );
                            },
                          ),

                          Gap(25),
                          // Role
                          commonHeader(UserManagementStrings.role),
                          Gap(10),
                          Obx(
                            () => AlwaysDownDropdown<String>(
                              hintText: "اختر",
                              items: controller.roleList,
                              value: controller.selectedRole.value.isEmpty
                                  ? null
                                  : controller.selectedRole.value,
                              onChanged: (val) {
                                controller.selectedRole.value = val ?? 'citizen';
                              },
                            ),
                          ),

                          Gap(25),
                          // Phone Number
                          commonHeader(UserManagementStrings.phoneNo),
                          Gap(10),
                          CommonMobileField(
                            controller: controller.phoneController,
                            textInputAction: TextInputAction.next,
                            hintText: UserManagementStrings.enterMobileNo,
                            onChanged: (phoneNumber) {
                              controller.completePhoneNumber.value = phoneNumber.completeNumber;
                            },
                          ),

                          Gap(25),
                          // Address
                          commonHeader('العنوان'),
                          Gap(10),
                          CommonTextField(
                            labelText: 'أدخل العنوان',
                            controller: controller.addressController,
                            textInputAction: TextInputAction.next,
                            hintText: 'أدخل العنوان',
                            maxLines: 3,
                            validator: (value) {
                              return validateEmptyValue(
                                value,
                                'العنوان مطلوب',
                              );
                            },
                          ),

                          Gap(25),
                          // Password (Optional)
                          CommonText.medium(
                            'كلمة المرور (اختياري - اتركها فارغة إذا كنت لا تريد تغييرها)',
                            size: 13,
                            color: isDarkMode ? AppColors.bodyTextDarkColor : AppColors.bodyTextColor,
                          ),
                          Gap(10),
                          CommonPasswordField(
                            labelText: 'كلمة المرور الجديدة',
                            controller: controller.passwordController,
                            textInputAction: TextInputAction.next,
                            hintText: 'أدخل كلمة المرور الجديدة (اختياري)',
                            validator: (value) {
                              // Password is optional on update
                              if (value != null && value.isNotEmpty && value.length < 8) {
                                return 'كلمة المرور يجب أن تكون 8 أحرف على الأقل';
                              }
                              return null;
                            },
                            onChange: (value) {},
                          ),

                          Gap(25),
                          // Confirm Password (Only if password entered)
                          commonHeader('تأكيد كلمة المرور'),
                          Gap(10),
                          CommonPasswordField(
                            labelText: 'تأكيد كلمة المرور',
                            controller: controller.passwordConfirmationController,
                            textInputAction: TextInputAction.done,
                            hintText: 'أدخل تأكيد كلمة المرور',
                            validator: (value) {
                              // Only validate if password is entered
                              if (controller.passwordController.text.isNotEmpty) {
                                if (value == null || value.isEmpty) {
                                  return 'تأكيد كلمة المرور مطلوب';
                                }
                                if (value != controller.passwordController.text) {
                                  return 'كلمة المرور غير متطابقة';
                                }
                              }
                              return null;
                            },
                            onChange: (value) {},
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
              child: Obx(() => Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      onPressed: () {
                        controller.clearForm();
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
                    child: controller.isLoading.value
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary500,
                            ),
                          )
                        : PrimaryButton(
                            onPressed: () async {
                              final isValid = formKey.currentState!.validate();
                              Get.focusScope!.unfocus();

                              if (!isValid) return;

                              formKey.currentState!.save();

                              await controller.updateUser(widget.user.id);
                              if (!controller.isLoading.value) {
                                Navigator.pop(context);
                              }
                            },
                            label: AppCommonStrings.btnUpdate,
                            textSize: 16,
                            textWeight: FontWeight.w500,
                          ),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
