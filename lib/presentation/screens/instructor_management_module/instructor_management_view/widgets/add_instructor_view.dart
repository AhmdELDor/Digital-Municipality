import 'package:education_admin_portal/presentation/common_widgets/widgets/common_divider.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/image.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/common_text_view/auth_common_text.dart';
import '../../../../common_widgets/input_field/common_email_field.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/view_common_widget/common_dialog_box.dart';
import '../../../../common_widgets/widgets/button.dart';
import '../../../../common_widgets/widgets/text.dart';
import '../../../../common_widgets/widgets/validations.dart';


class AddDetailView extends StatefulWidget {
  final String title;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final void Function()? onPressed;
  final Key? formKey;

  const AddDetailView({
    super.key,
    required this.title,
    required this.nameController,
    this.onPressed,
    this.formKey,

    required this.emailController,
  });

  @override
  State<AddDetailView> createState() => _AddDetailViewState();
}

class _AddDetailViewState extends State<AddDetailView> {
  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding:  EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.semiBold(
                  widget.title,
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
                  hintText: AddInstructorStrings.enterName,
                  controller: widget.nameController,
                  textInputAction: TextInputAction.next,

                  validator: (value) {
                    return validateEmptyValue(value, 'Please Enter Name');
                  },
                ),
                Gap(25),
                authHeader(AppCommonStrings.email),
                Gap(10),
                CommonEmailField(
                  labelText: AppCommonStrings.email,
                  autofillHints: const [AutofillHints.email],
                  controller: widget.emailController,
                  textInputAction: TextInputAction.done,
                  hintText: AddInstructorStrings.enterEmail,
                  validator: validateEmail,
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
                        onPressed: widget.onPressed,
                        label: AddInstructorStrings.sendInvite,
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

class CommonDialogView extends StatefulWidget {
  final String image, title, subtitle, buttonName;
  final Color buttonBackgroundColor;
  final void Function()? onPressed;

  const CommonDialogView({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.buttonBackgroundColor,
    required this.buttonName,
    this.onPressed,
  });

  @override
  State<CommonDialogView> createState() => _InviteSentViewViewState();
}

class _InviteSentViewViewState extends State<CommonDialogView> {
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
              child: commonCloseIcon(context)),
          Gap(20),
          SvgImageFromAsset(widget.image),
          Gap(20),
          CommonText.medium(widget.title, size: 19),
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
                  borderSide: BorderSide(color: AppColors.primary500),
                  textColor: AppColors.primary500,
                  textSize: 18,
                  textWeight: FontWeight.w600,
                ),
              ),
              Gap(15),
              Expanded(
                child: PrimaryButton(
                  onPressed: widget.onPressed,
                  label: widget.buttonName,
                  backgroundColor: widget.buttonBackgroundColor,
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
