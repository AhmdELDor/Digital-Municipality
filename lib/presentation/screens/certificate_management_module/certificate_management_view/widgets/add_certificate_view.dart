import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/certificate_management_view_controller.dart';

class AddCertificateView extends StatefulWidget {
  const AddCertificateView({super.key});

  @override
  State<AddCertificateView> createState() => _AddCertificateViewState();
}

class _AddCertificateViewState extends State<AddCertificateView> {
  CertificateManagementViewController controller = Get.put(
    CertificateManagementViewController(),
  );
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
                      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CommonText.semiBold(
                            CertificateManagementStrings.addCertificate,
                            size: 18,
                          ),
                          commonCloseIcon(context),
                        ],
                      ),
                    ),
      
                    CommonDivider(),
                    Gap(25),
      
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20,),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          authHeader(CertificateManagementStrings.logo),
                          Gap(10),
                          CommonTextField(
                            labelText: CourseCategoryStrings.select,
                            controller: controller.logoController,
                            textInputAction: TextInputAction.next,
                            hintText: CourseCategoryStrings.select,
                            validator: (value) {
                              return validateEmptyValue(value, 'This Field is Required');
                            },
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  controller.pickFileCommon(controller.logoController);
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
                                      CertificateManagementStrings.chooseFile,
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
      
                          Gap(25),
                          authHeader(CertificateManagementStrings.background),
                          Gap(10),
                          CommonTextField(
                            labelText: CourseCategoryStrings.select,
                            controller: controller.backgroundController,
                            textInputAction: TextInputAction.next,
                            hintText: CourseCategoryStrings.select,
                            validator: (value) {
                              return validateEmptyValue(value, 'This Field is Required');
                            },
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 12),
                              child: InkWell(
                                onTap: () {
                                  controller.pickFileCommon(controller.backgroundController);
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
                                      CertificateManagementStrings.chooseFile,
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
      
                          Gap(25),
                          commonHeader(CertificateManagementStrings.studentName),
                          Gap(10),
                          CommonTextField(
                            labelText: CertificateManagementStrings.enterStudentName,
                            controller: controller.studentNamedController,
                            textInputAction: TextInputAction.next,
                            hintText:CertificateManagementStrings.enterStudentName,
                            validator: (value) {
                              return validateEmptyValue(value, 'Student Name is Required');
                            },
                          ),
      
                          Gap(25),
                          commonHeader(CertificateManagementStrings.course),
                          Gap(10),
                          Obx(
                            () => AlwaysDownDropdown<String>(
                              hintText: "Select",
                              items: controller.courseList,
                              value: controller.selectedCourse.value.isEmpty
                                  ? null
                                  : controller.selectedCourse.value,
                              onChanged: (val) {
                                controller.selectedCourse.value = val ?? '';
                              },
                              //validator: (val) => val == null || val.isEmpty ? "Select" : null,
                            ),
                          ),
      
                          Gap(25),
                          commonHeader(CertificateManagementStrings.customText),
                          Gap(10),
                          CommonTextField(
                            labelText: CertificateManagementStrings.enterCustomText,
                            controller: controller.customTextController,
                            textInputAction: TextInputAction.next,
                            hintText: CertificateManagementStrings.enterCustomText,
                            validator: (value) {
                              return validateEmptyValue(value, 'This Field is Required');
                            },
                          ),
                          Gap(25),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonHeader(CertificateManagementStrings.completionDate),
                                    Gap(10),
                                    CommonDatePicker(
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
                                ),
                              ),
                              Gap(20),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    commonHeader(CertificateManagementStrings.signature),
                                    Gap(10),
                                    CommonTextField(
                                      labelText: CourseCategoryStrings.select,
                                      controller: controller.signatureController,
                                      textInputAction: TextInputAction.done,
                                      hintText: CourseCategoryStrings.select,
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
                                              controller.signatureController,
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
                                                CertificateManagementStrings.chooseFile,
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
                          Gap(30),
                        ],
                      ),
                    ),
      
      
      
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 25),
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
                      label: CertificateManagementStrings.addCertificate,
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
