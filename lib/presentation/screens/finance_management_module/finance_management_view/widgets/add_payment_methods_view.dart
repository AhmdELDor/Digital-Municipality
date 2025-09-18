import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../utils/extensions/responsive.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/common_divider.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/finance_management_controller.dart';


class AddPaymentMethodView extends StatefulWidget {
  const AddPaymentMethodView({super.key});

  @override
  State<AddPaymentMethodView> createState() => _AddPaymentMethodViewState();
}

class _AddPaymentMethodViewState extends State<AddPaymentMethodView> {
  FinanceManagementController controller = Get.put(FinanceManagementController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
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
                    FinanceManagementStrings.addPaymentMethod,
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
                  CommonText.medium(AddCoursesStrings.name, size: 15),
                  Gap(10),
                  CommonTextField(
                    hintText: AddNoteStrings.enterTitle,
                    controller: controller.nameController,
                    textInputAction: TextInputAction.next,
                    validator: (value) {
                      return validateEmptyValue(value, 'Please Enter Title');
                    },
                  ),
                  Gap(25),
                  authHeader(CourseCategoryStrings.image),
                  Gap(10),
                  CommonTextField(
                    labelText: CourseCategoryStrings.select,
                    controller: controller.fileController,
                    textInputAction: TextInputAction.done,
                    hintText: CourseCategoryStrings.select,
                    validator: (value) {
                      return validateEmptyValue(value, 'This Field is Required');
                    },
                    suffixIcon: Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: InkWell(
                        onTap: () {
                          controller.pickFileCommon(controller.fileController);
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
                  Gap(40),
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
                          label: mobileView?CourseCategoryStrings.add:FinanceManagementStrings.addPaymentMethod,
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
}
