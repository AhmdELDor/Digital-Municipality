import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/input_field/common_email_field.dart';
import '../../../../common_widgets/input_field/common_mobile_field.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/profile_view_controller.dart';

class EditPersonalInformation extends StatefulWidget {
  const EditPersonalInformation({super.key});

  @override
  State<EditPersonalInformation> createState() =>
      _EditPersonalInformationState();
}

class _EditPersonalInformationState extends State<EditPersonalInformation> {
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
              CommonText.semiBold(
                ProfileViewStrings.editPersonalInformation,
                size: 18,
              ),
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
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonHeader(ProfileViewStrings.fName),
                              Gap(10),
                              CommonTextField(
                                hintText: ProfileViewStrings.name,
                                controller: controller.firstNameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return validateEmptyValue(
                                    value,
                                    'First Name is Required',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Gap(20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonHeader(ProfileViewStrings.lName),
                              Gap(10),
                              CommonTextField(
                                hintText: ProfileViewStrings.name,
                                controller: controller.lastNameController,
                                textInputAction: TextInputAction.next,
                                validator: (value) {
                                  return validateEmptyValue(
                                    value,
                                    'Last Name is Required',
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Gap(20),

                    commonHeader(ProfileViewStrings.joinedDate),
                    Gap(10),
                    CommonClassDatePicker(
                      hintText: AddClassStrings.selectDate,
                      controller: controller.joiningDateController,
                      fillColor: Colors.transparent,
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

                    Gap(20),
                    commonHeader(ProfileViewStrings.email),
                    Gap(10),
                    CommonEmailField(
                      labelText: AppCommonStrings.email,
                      autofillHints: const [AutofillHints.email],
                      controller: controller.emailController,
                      textInputAction: TextInputAction.done,
                      hintText: AddInstructorStrings.enterEmail,
                      validator: validateEmail,
                    ),

                    Gap(20),
                    commonHeader(ProfileViewStrings.phoneNo),
                    Gap(10),
                    CommonMobileField(hintText: ProfileViewStrings.phoneNo),

                    Gap(20),
                    commonHeader(ProfileViewStrings.userRole),
                    Gap(10),
                    Obx(
                          () => AlwaysDownDropdown<String>(
                        hintText: "Select",
                        items: controller.roleList,
                        value: controller.selectedRole.value,
                        onChanged: (val) {
                          controller.selectedRole.value = val!;
                        },

                        //validator: (val) => val == null ? "Select" : null,
                      ),
                    ),
                    
                  ],
                ),
              ),
            ),
          ),
        ),
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
