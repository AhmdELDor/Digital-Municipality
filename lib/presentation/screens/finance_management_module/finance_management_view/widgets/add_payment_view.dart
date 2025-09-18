import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../quiz_module/quiz_main_view/model/status_model.dart';
import '../controller/finance_management_controller.dart';
import '../model/payment_method_model.dart';

class AddPaymentView extends StatefulWidget {
  const AddPaymentView({super.key});

  @override
  State<AddPaymentView> createState() => _AddPaymentViewState();
}

class _AddPaymentViewState extends State<AddPaymentView> {
  FinanceManagementController controller = Get.put(
    FinanceManagementController(),
  );

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.semiBold(
                    FinanceManagementStrings.addPayment,
                    size: 18,
                  ),
                  commonCloseIcon(context),
                ],
              ),
            ),
            CommonDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CommonText.medium(FinanceManagementStrings.course, size: 15),
                  Gap(10),
                  Obx(() {
                    return AlwaysDownDropdown<CourseModel>(
                      hintText: "Select",
                      items: controller.data.value.coursesList,
                      value: controller.selectedCourse.value,
                      onChanged: (val) {
                        controller.selectedCourse.value = val;
                      },
                      itemAsString: (item) => item.name,
                      //validator: (val) => val == null ? "Payment Method" : null,
                    );

                    //   DropdownButtonFormField<CourseModel>(
                    //   value: controller.selectedCourse.value,
                    //   items: controller.data.value.coursesList
                    //       .map(
                    //         (course) => DropdownMenuItem(
                    //           value: course,
                    //           child: CommonText.regular(
                    //             course.name,
                    //             size: 14,
                    //             color: isDarkMode
                    //                 ? AppColors.bodyTextDarkColor
                    //                 : AppColors.bodyTextColor,
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    //   onChanged: (val) {
                    //     if (val != null) {
                    //       controller.selectedCourse.value = val;
                    //     }
                    //   },
                    //   decoration: commonInputDecoration(
                    //     FinanceManagementStrings.select,
                    //     context,
                    //   ),
                    // );
                  }),
      
                  Gap(25),
      
                  commonHeader(FinanceManagementStrings.amount),
                  Gap(10),
                  CommonTextField(
                    hintText: FinanceManagementStrings.enterAmount,
                    controller: controller.nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return validateEmptyValue(value, 'Please Enter Amount');
                    },
                  ),
      
                  Gap(25),
                  commonHeader(FinanceManagementStrings.paymentMethod),
                  Gap(10),
                  Obx(() {
                    return AlwaysDownDropdown<PaymentMethodModel>(
                      hintText: "Select",
                      items: controller.data.value.paymentMethodsList,
                      value: controller.selectedPaymentMethod.value,
                      onChanged: (val) {
                        controller.selectedPaymentMethod.value = val;
                      },
                      itemAsString: (item) => item.name,
                      //validator: (val) => val == null ? "Payment Method" : null,
                    );

                    //   DropdownButtonFormField<PaymentMethodModel>(
                    //   value: controller.selectedPaymentMethod.value,
                    //   items: controller.data.value.paymentMethodsList
                    //       .map(
                    //         (course) => DropdownMenuItem(
                    //           value: course,
                    //           child: CommonText.regular(
                    //             course.name,
                    //             size: 14,
                    //             color: isDarkMode
                    //                 ? AppColors.bodyTextDarkColor
                    //                 : AppColors.bodyTextColor,
                    //             fontWeight: FontWeight.w400,
                    //           ),
                    //         ),
                    //       )
                    //       .toList(),
                    //   onChanged: (val) {
                    //     if (val != null) {
                    //       controller.selectedPaymentMethod.value = val;
                    //     }
                    //   },
                    //   decoration: commonInputDecoration(
                    //     FinanceManagementStrings.select,
                    //     context,
                    //   ),
                    // );
                  }),
                  Gap(25),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonHeader(FinanceManagementStrings.paymentDate),
                            Gap(10),
                            CommonTextField(
                              hintText: FinanceManagementStrings.select,
                              controller: controller.addPaymentDateController,
                              textInputAction: TextInputAction.next,
                              suffixIcon: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: SvgImageFromAsset(
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
                              ),
                              onTap: () {
                                _selectDate(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      Gap(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                commonHeader(FinanceManagementStrings.usedCoins),
                                CommonText.regular(
                                  FinanceManagementStrings.ifApplicable,
                                  size: 13,
                                  color: isDarkMode
                                      ? AppColors.bodyTextDarkColor
                                      : AppColors.bodyTextColor,
                                ),
                              ],
                            ),
                            Gap(10),
                            CommonTextField(
                              hintText: FinanceManagementStrings.enterUsedCoins,
                              controller: controller.coinsController,
                              textInputAction: TextInputAction.next,
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(25),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonHeader(FinanceManagementStrings.paymentId),
                            Gap(10),
                            CommonTextField(
                              hintText: FinanceManagementStrings.enterPaymentId,
                              controller: controller.paymentIdController,
                              textInputAction: TextInputAction.next,
                            ),
                          ],
                        ),
                      ),
                      Gap(15),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            commonHeader(FinanceManagementStrings.status),
                            Gap(10),
                            Obx(() {
                              return AlwaysDownDropdown<StatusModel>(
                                hintText: "Select",
                                items: controller.data.value.statusList,
                                value: controller.selectedStatus.value,
                                onChanged: (val) {
                                  controller.selectedStatus.value = val;
                                },
                                itemAsString: (item) => item.name,
                                //validator: (val) => val == null ? "Payment Method" : null,
                              );

                              //   DropdownButtonFormField<StatusModel>(
                              //   value: controller.selectedStatus.value,
                              //   items: controller.data.value.statusList
                              //       .map(
                              //         (course) => DropdownMenuItem(
                              //           value: course,
                              //           child: CommonText.regular(
                              //             course.name,
                              //             size: 14,
                              //             color: isDarkMode
                              //                 ? AppColors.bodyTextDarkColor
                              //                 : AppColors.bodyTextColor,
                              //             fontWeight: FontWeight.w400,
                              //           ),
                              //         ),
                              //       )
                              //       .toList(),
                              //   onChanged: (val) {
                              //     if (val != null) {
                              //       controller.selectedStatus.value = val;
                              //     }
                              //   },
                              //   decoration: commonInputDecoration(
                              //     FinanceManagementStrings.select,
                              //     context,
                              //   ),
                              // );
                            }),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Gap(25),
                  Row(
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
                            Navigator.of(
                              context,
                              rootNavigator: true,
                            ).pop();
                          },
                          label: FinanceManagementStrings.addPayment,
                          textSize: 16,
                          textWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: DateTime(DateTime.now().year - 100),
      lastDate: DateTime.now().subtract(const Duration(days: 18 * 365)),
      currentDate: DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return datePickerTheme(child);
      },
    );
    if (picked != null) {
      final formattedDate = DateFormat('dd MMMM yyyy').format(picked);
      controller.dateController.text = formattedDate; // ✅ display in field
      //widget.onDatePicked(formattedDate); // ✅ callback for controller or logic
    }
  }
}
