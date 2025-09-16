import 'package:education_admin_portal/presentation/common_widgets/view_common_widget/common_dialog_box.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';
import '../controller/setting_view_controller.dart';

class AddPrivacyPolicy extends StatefulWidget {
  const AddPrivacyPolicy({super.key});

  @override
  State<AddPrivacyPolicy> createState() => _AddPrivacyPolicyState();
}

class _AddPrivacyPolicyState extends State<AddPrivacyPolicy> {
  SettingViewController controller = Get.put(SettingViewController());
  @override
  Widget build(BuildContext context) {
    return Form(
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
                  SettingViewStrings.addPrivacyPolicy,
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
                commonHeader(SettingViewStrings.privacyPolicy),
                Gap(10),
                CommonTextField(
                  hintText: SettingViewStrings.enterPrivacyPolicy,
                  controller: controller.privacyPolicyController,
                  textInputAction: TextInputAction.done,
                  maxLines: 3,
                  validator: (value) {
                    return validateEmptyValue(value, 'This Filed is Required');
                  },
                ),

                Gap(30),
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
                          final isValid = controller.formKey.currentState!
                              .validate();
                          FocusScope.of(
                            context,
                          ).unfocus(); // ✅ safer than Get.focusScope

                          if (!isValid) return;

                          controller.formKey.currentState!.save();
                          // ✅ Close previous dialog safely
                          Navigator.of(context, rootNavigator: true).pop();
                        },
                        label: SettingViewStrings.addPrivacyPolicy,
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
    );
  }
}
