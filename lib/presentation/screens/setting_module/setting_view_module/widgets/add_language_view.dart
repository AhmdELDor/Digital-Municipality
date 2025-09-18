import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/view_common_widget/custom_dropdown_button.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../controller/setting_view_controller.dart';
import '../model/language_model.dart';

class AddLanguageView extends StatefulWidget {
  const AddLanguageView({super.key});

  @override
  State<AddLanguageView> createState() => _AddLanguageViewState();
}

class _AddLanguageViewState extends State<AddLanguageView> {
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
                CommonText.semiBold(SettingViewStrings.addLanguage, size: 18),
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
                commonHeader(CourseApprovalsDetailStrings.language),
                Gap(10),
                Obx(
                  () => AlwaysDownDropdown<LanguageModel>(
                    color: Colors.transparent,
                    hintText: "Select",
                    items: controller.setting.value.languageList,
                    value: controller.selectedLanguage.value,
                    onChanged: (val) {
                      controller.selectedLanguage.value=val;
                    },
                    itemAsString: (item) => item.name,

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
                        label: SettingViewStrings.addLanguage,
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
