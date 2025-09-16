import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:responsive_grid/responsive_grid.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_date_picker.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/custom_app_bar.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/image.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../../../dashboard_module/dashboard/model/user_model.dart';
import '../../../quiz_module/quiz_main_view/model/status_model.dart';
import '../../../side_drawer_module/side_drawer_menu/side_drawer_imports.dart';
import '../controller/finance_management_controller.dart';
import '../model/occurrence_model.dart';
import '../model/payment_method_model.dart';

class AddInstructorPayOut extends StatefulWidget {
  const AddInstructorPayOut({super.key});

  @override
  State<AddInstructorPayOut> createState() => _AddInstructorPayOutState();
}

class _AddInstructorPayOutState extends State<AddInstructorPayOut> {
  FinanceManagementController controller = Get.put(
    FinanceManagementController(),
  );
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
      key: _scaffoldKey,
      drawer: const SizedBox(width: 270, child: SideDrawerMenu()),
      appBar: CustomAppBar(
        searchController: controller.searchController,
        drawerOnTap: () {
          _scaffoldKey.currentState?.openDrawer();
        },
      ),
      body: SingleChildScrollView(
        child: Form(
          key: controller.formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [

              Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                child: CommonText.semiBold(
                  FinanceManagementStrings.addInstructorPayout,
                  size: 18,
                ),
              ),
              CommonDivider(),
              ResponsiveGridRow(
                children: [
                  ResponsiveGridCol(
                    lg: 10,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: mobileView?0:20,
                          vertical:mobileView?0:20,
                        ),
                        decoration:mobileView?null: BoxDecoration(
                          color: isDarkMode
                              ? AppColors.mainDarkBgColor
                              : AppColors.white,
                          border: Border.all(
                            color: isDarkMode
                                ? AppColors.grey100Color
                                : AppColors.lightBorderColor,
                            width: 1,
                          ),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                          mobileView?deviceView(): desktopView(isDarkMode)
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget desktopView(bool isDarkMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  instructorDropDown(),
                  Gap(20),
                  paymentDateView(),
                  Gap(20),
                  noOfPaymentView(),
                  Gap(20),
                  paymentIdView(),
                ],
              ),
            ),
            Gap(25),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  occurrenceDropDown(),
                  Gap(20),
                  paymentMethodDropDown(),
                  Gap(20),
                  paymentAmount(),
                  Gap(20),
                  paymentsStatusView(),
                ],
              ),
            ),
          ],
        ),
        Gap(30),
        Row(
          children: [
            SizedBox(
              width: 160,
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: AppCommonStrings.btnCancel,
                borderSide: BorderSide(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                ),
                textColor: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                textSize: 16,
                textWeight: FontWeight.w500,
                backgroundColor: isDarkMode
                    ? AppColors.mainDarkBgColor
                    : AppColors.lightBorderColor,
              ),
            ),
            Gap(15),
            SizedBox(
              width: 160,
              child: PrimaryButton(
                onPressed: () {},
                label: FinanceManagementStrings.addPayOut,
                textSize: 16,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget deviceView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        instructorDropDown(),
        Gap(20),
        occurrenceDropDown(),
        Gap(20),
        paymentDateView(),
        Gap(20),
        paymentMethodDropDown(),
        Gap(20),
        noOfPaymentView(),
        Gap(20),
        paymentAmount(),
        Gap(20),
        paymentIdView(),
        Gap(20),
        paymentsStatusView(),
        Gap(20),
        Row(
          children: [
            Expanded(
              child: PrimaryButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                label: AppCommonStrings.btnCancel,
                borderSide: BorderSide(
                  color: isDarkMode
                      ? AppColors.grey100Color
                      : AppColors.lightBorderColor,
                ),
                textColor: isDarkMode
                    ? AppColors.bodyTextDarkColor
                    : AppColors.bodyTextColor,
                textSize: 16,
                textWeight: FontWeight.w500,
                backgroundColor: isDarkMode
                    ? AppColors.mainDarkBgColor
                    : AppColors.lightBorderColor,
              ),
            ),
            Gap(15),
            Expanded(
              child: PrimaryButton(
                onPressed: () {},
                label: FinanceManagementStrings.addPayOut,
                textSize: 16,
                textWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  //instructor drop down
  Widget instructorDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.instructor),
        Gap(10),
        Obx(
          () => AlwaysDownDropdown<UserModel>(
            hintText: "Select instructor",
            items: controller.data.value.instructorList,
            value: controller.selectedInstructor.value,
            onChanged: (val) {
              controller.selectedInstructor.value = val;
            },
            itemAsString: (item) => item.name,
            //validator: (val) => val == null ? "Select instructor" : null,
          ),
        ),
      ],
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
            value: controller.selectedOccurrence.value,
            onChanged: (val) {
              controller.selectedOccurrence.value = val;
            },
            itemAsString: (item) => item.name,
            //validator: (val) => val == null ? "Select" : null,
          ),
        ),
      ],
    );
  }

  //payment date
  Widget paymentDateView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.paymentDate),
        Gap(10),
        CommonDatePicker(
          hintText: AddClassStrings.selectDate,
          controller: controller.instructorDatePaymentController,
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

  //payment method drop down
  Widget paymentMethodDropDown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.paymentMethod),
        Gap(10),
        AlwaysDownDropdown<PaymentMethodModel>(
          hintText: "Payment Method",
          items: controller.data.value.paymentMethodsList,
          value: controller.selectedInstructorPaymentMethod.value,
          onChanged: (val) {
            controller.selectedInstructorPaymentMethod.value = val;
          },
          itemAsString: (item) => item.name,
          //validator: (val) => val == null ? "Payment Method" : null,
        ),
      ],
    );
  }

  Widget noOfPaymentView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.noOfPayment),
        Gap(10),
        CommonTextField(
          hintText: FinanceManagementStrings.enterNoOfPayment,
          controller: controller.noOfPaymentController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'This Field is Required');
          },
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () {
                    int current =
                        int.tryParse(controller.noOfPaymentController.text) ??
                        0;
                    current++;
                    controller.noOfPaymentController.text = current.toString();
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
                        int.tryParse(controller.noOfPaymentController.text) ??
                        0;
                    if (current > 0) {
                      current--; // don’t go below 0
                    }
                    controller.noOfPaymentController.text = current.toString();
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

  Widget paymentAmount() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.paymentAmount),
        Gap(10),
        CommonTextField(
          hintText: FinanceManagementStrings.enterPaymentAmount,
          controller: controller.paymentAmountController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Please Enter Amount');
          },
        ),
      ],
    );
  }

  Widget paymentIdView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.paymentID),
        Gap(10),
        CommonTextField(
          hintText: FinanceManagementStrings.enterPaymentId,
          controller: controller.instructorPaymentIdController,
          textInputAction: TextInputAction.next,
          validator: (value) {
            return validateEmptyValue(value, 'Please Enter Payment Id');
          },
        ),
      ],
    );
  }

  Widget paymentsStatusView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        authHeader(FinanceManagementStrings.paymentStatus),
        Gap(10),
        AlwaysDownDropdown<StatusModel>(
          hintText: "Status",
          items: controller.data.value.statusList,
          value: controller.selectedInstructorStatus.value,
          onChanged: (val) {
            controller.selectedInstructorStatus.value = val;
          },
          itemAsString: (item) => item.name,
          //validator: (val) => val == null ? "Status" : null,
        ),
      ],
    );
  }
}
