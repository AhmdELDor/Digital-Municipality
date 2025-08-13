import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_strings.dart';
import '/presentation/common_widgets/widgets/text.dart';
import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import 'button.dart';

class CommonAlertDialog extends StatelessWidget {
  final String title;
  final String subTitle;
  final String primaryButtonTitle;

  final VoidCallback primaryButtonPressed;

  const CommonAlertDialog({
    super.key,
    required this.title,
    required this.subTitle,
    required this.primaryButtonTitle,
    required this.primaryButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Get.find<ThemeController>().isDarkMode
          ? AppColors.headingsColor
          : AppColors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CommonText.bold(title, size: 18),
              const Gap(15),
              CommonText.medium(subTitle, size: 14, color: AppColors.greyColor),

              const Gap(30),
              Row(
                children: [
                  Expanded(
                    child: OutlineButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      label: AppCommonStrings.btnCancel,
                    ),
                  ),
                  Gap(20),
                  Expanded(
                    child: PrimaryButton(
                      backgroundColor: AppColors.error500,
                      onPressed: primaryButtonPressed,
                      label: primaryButtonTitle,
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
}

Future<void> commonDialog({
  required BuildContext context,
  required Widget view,
  EdgeInsets? insetPadding,
}) async {
  bool isDarkMode = Get.find<ThemeController>().isDarkMode;
  return showDialog(
    context: context,
    builder: (context) {
      return Dialog(
        // backgroundColor: isDarkMode
        //     ? AppColors.cardDarkBgColor
        //     : AppColors.mainBgColor,
        insetPadding: insetPadding ?? EdgeInsets.symmetric(horizontal: 15),

        child: Container(
          decoration: isDarkMode
              ? AppCommonShadow.commonDarkBoxShadow
              : AppCommonShadow.commonBoxShadow,

          child: SingleChildScrollView(child: view),
        ),
      );
    },
  );
}
