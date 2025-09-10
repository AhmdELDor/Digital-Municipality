import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/text.dart';

class CommonDeleteDialogBox extends StatefulWidget {
  final String tittle,subtitle;
  final  void Function()? doneOnPressed;
  const CommonDeleteDialogBox({super.key, required this.tittle, required this.subtitle, this.doneOnPressed});

  @override
  State<CommonDeleteDialogBox> createState() =>
      _CommonDeleteDialogBoxState();
}

class _CommonDeleteDialogBoxState extends State<CommonDeleteDialogBox> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: commonCloseIcon(context),
          ),
          Gap(20),
          SvgImageFromAsset(CommonImageAssets.deleteCategory),
          Gap(20),
          CommonText.medium(widget.tittle, size: 19),
          Gap(20),
          CommonText.regular(
            widget.subtitle,
            size: 15,
            color: isDarkMode
                ? AppColors.bodyTextDarkColor
                : AppColors.bodyTextColor,
            textAlign: TextAlign.center,
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
                  borderSide: BorderSide(color: isDarkMode?AppColors.grey100Color:AppColors.headingsLightColor),
                  textColor: AppColors.greyTextColor,
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
              ),
              Gap(15),
              Expanded(
                child: PrimaryButton(
                  onPressed: widget.doneOnPressed,
                  label: ApprovalsStrings.delete,
                  backgroundColor: AppColors.error500,
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
