import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../app/theme_controller.dart';
import '../controller/setting_view_controller.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  SettingViewController controller = Get.put(SettingViewController());
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Container(
        decoration: BoxDecoration(
          color: isDarkMode ? AppColors.mainDarkBgColor : AppColors.white,
          border: Border.all(
            color: isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: ListView.builder(
          itemCount: controller.setting.value.privacyPolicyList.length,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 20),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12),
                    child: CircleAvatar(
                      radius: 3,
                      backgroundColor: AppColors.textDisabledColor,
                    ),
                  ),
                  Gap(15),
                  Expanded(
                    child: CommonText.regular(
                      controller.setting.value.privacyPolicyList[index],
                      size: 16,
                      color: AppColors.textDisabledColor,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
