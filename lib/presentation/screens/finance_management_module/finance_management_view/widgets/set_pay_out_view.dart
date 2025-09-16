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
import '../controller/finance_management_controller.dart';
import '../model/occurrence_model.dart';
import '../model/payment_method_model.dart';

class SetPayOutView extends StatefulWidget {
  const SetPayOutView({super.key});

  @override
  State<SetPayOutView> createState() => _SetPayOutViewState();
}

class _SetPayOutViewState extends State<SetPayOutView> {
  FinanceManagementController controller = Get.put(
    FinanceManagementController(),
  );

  @override
  Widget build(BuildContext context) {
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
                    FinanceManagementStrings.setPayOutText,
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
                  occurrenceDropDown(),
                  Gap(20),
                  everyMonthView(),
                  Gap(20),
                  totalRevenue(),
                  Gap(20),
                  paymentMethodView(),
      
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
                            Navigator.pop(context);
                          },
                          label: FinanceManagementStrings.setPayOutText,
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

  //occurrence drop down
  Widget occurrenceDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.occurrence),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<OccurrenceModel>(
            hintText: "Select",
            items: controller.data.value.occurrenceList,
            value: controller.selectedSetOccurrence.value,
            onChanged: (val) {
              controller.selectedSetOccurrence.value = val;
            },
            itemAsString: (item) => item.name,
            //validator: (val) => val == null ? "Select" : null,
          ),
        ),
      ],
    );
  }

  Widget everyMonthView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeader(FinanceManagementStrings.everyMonths),
        Gap(10),
        CommonTextField(
          hintText: AddClassStrings.selectDate,
          controller: controller.everyMonthDateController,
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
    );
  }

  Widget totalRevenue() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeader(FinanceManagementStrings.totalRevenue),
        Gap(10),
        CommonTextField(
          hintText: FinanceManagementStrings.enterPercent,
          controller: controller.revenueController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
        ),
      ],
    );
  }

  Widget paymentMethodView() {
    //bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        commonHeader(FinanceManagementStrings.paymentMethod),
        Gap(10),
        Obx(() {
          return AlwaysDownDropdown<PaymentMethodModel>(
            hintText: "Select",
            items: controller.data.value.paymentMethodsList,
            value: controller.payOutPaymentMethod.value,
            onChanged: (val) {
              controller.payOutPaymentMethod.value = val;
            },
            itemAsString: (item) => item.name,
            //validator: (val) => val == null ? "Payment Method" : null,
          );

          //   DropdownButtonFormField<PaymentMethodModel>(
          //   value: controller.payOutPaymentMethod.value,
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
          //       controller.payOutPaymentMethod.value = val;
          //     }
          //   },
          //   decoration: commonInputDecoration(
          //     FinanceManagementStrings.select,
          //     context,
          //   ),
          // );
        }),
      ],
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
      controller.everyMonthDateController.text = formattedDate; // ✅ display in field
      //widget.onDatePicked(formattedDate); // ✅ callback for controller or logic
    }
  }
}
