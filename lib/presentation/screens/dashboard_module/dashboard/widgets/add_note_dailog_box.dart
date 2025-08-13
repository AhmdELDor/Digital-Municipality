import 'package:education_admin_portal/core/constants/app_assets.dart';
import 'package:education_admin_portal/presentation/app/app_route.dart';
import 'package:education_admin_portal/presentation/common_widgets/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../app/theme_controller.dart';
import '../../../../common_widgets/input_field/common_password_field.dart';
import '../../../../common_widgets/input_field/common_text_field.dart';
import '../../../../common_widgets/widgets/validations.dart';

class AddNoteDialogBox extends StatefulWidget {
  final TextEditingController titleController;
  final TextEditingController noteController;

  const AddNoteDialogBox({
    super.key,
    required this.titleController,
    required this.noteController,
  });

  @override
  State<AddNoteDialogBox> createState() => _AddNoteDialogBoxState();
}

class _AddNoteDialogBoxState extends State<AddNoteDialogBox> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.medium(AddNoteStrings.addNote, size: 14),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgImageFromAsset(AppCommonIcon.clockIcon),
                ),
              ],
            ),
            Gap(15),
            CommonText.regular(AddNoteStrings.title, size: 14),
            Gap(10),
            CommonTextField(
              hintText: AddNoteStrings.enterTitle,
              controller: widget.titleController,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return validateEmptyValue(value, 'Title is Required');
              },
            ),

            Gap(15),
            CommonText.regular(AddNoteStrings.note, size: 14),
            Gap(10),
            CommonTextField(
              hintText: AddNoteStrings.enterNote,
              maxLines: 3,
              controller: widget.noteController,
              // validator: (value) {
              //   return  validateEmptyValue(value,'Title is Required');
              // },
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
                Gap(20),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      Get.focusScope!.unfocus();

                      if (!isValid) return;

                      formKey.currentState!.save();

                      Navigator.pop(context);
                    },
                    label: AddNoteStrings.saveNote,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ChangePasswordDialogBox extends StatefulWidget {
  final TextEditingController currentPasswordController;
  final TextEditingController newPasswordController;
  final TextEditingController confirmPasswordController;

  const ChangePasswordDialogBox({
    super.key,
    required this.currentPasswordController,
    required this.newPasswordController,
    required this.confirmPasswordController,
  });

  @override
  State<ChangePasswordDialogBox> createState() =>
      _ChangePasswordDialogBoxState();
}

class _ChangePasswordDialogBoxState extends State<ChangePasswordDialogBox> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CommonText.medium(
                  ChangesPasswordStrings.changePassword,
                  size: 14,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: SvgImageFromAsset(AppCommonIcon.clockIcon),
                ),
              ],
            ),
            Gap(15),
            CommonText.regular(
              ChangesPasswordStrings.currentPassword,
              size: 14,
            ),
            Gap(10),
            CommonPasswordField(
              labelText: '',
              autofillHints: const [AutofillHints.password],
              controller: widget.currentPasswordController,
              textInputAction: TextInputAction.next,
              validator: validatePassword,
              hintText: ChangesPasswordStrings.enterPassword,
              onChange: (String? value) {},
              fillColor: Colors.transparent,
              onFieldSubmitted: (value) {
                FocusScope.of(context).nextFocus();
              },
            ),

            Gap(15),
            CommonText.regular(ChangesPasswordStrings.newPassword, size: 14),
            Gap(10),
            CommonPasswordField(
              labelText: '',
              autofillHints: const [AutofillHints.password],
              controller: widget.newPasswordController,

              textInputAction: TextInputAction.next,
              validator: validatePassword,
              hintText: ChangesPasswordStrings.enterNewPassword,
              fillColor: Colors.transparent,
              onChange: (String? value) {},
              onFieldSubmitted: (value) {
                FocusScope.of(context).nextFocus();
              },
            ),
            Gap(25),

            Gap(15),
            CommonText.regular(
              ChangesPasswordStrings.confirmPassword,
              size: 14,
            ),
            Gap(10),
            CommonPasswordField(
              autofillHints: const [AutofillHints.password],
              controller: widget.confirmPasswordController,

              textInputAction: TextInputAction.done,
              hintText: ChangesPasswordStrings.confirmPassword,
              onChange: (String? value) {},
              fillColor: Colors.transparent,
              validator: (value) => validateConfirmPassword(
                value,
                widget.newPasswordController.text,
              ),
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
                Gap(20),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      final isValid = formKey.currentState!.validate();
                      Get.focusScope!.unfocus();

                      if (!isValid) return;

                      formKey.currentState!.save();

                      Navigator.pop(context);
                    },
                    label: ChangesPasswordStrings.changePassword,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class LogOutDialogBox extends StatefulWidget {
  const LogOutDialogBox({super.key});

  @override
  State<LogOutDialogBox> createState() => _LogOutDialogBoxState();
}

class _LogOutDialogBoxState extends State<LogOutDialogBox> {
  final formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: SvgImageFromAsset(AppCommonIcon.closeIcon),
              ),
            ),
            Gap(20),
            SvgImageFromAsset(CommonImageAssets.logOut,height: 48,width: 48,),
            Gap(20),
            CommonText.medium(
              LogOutStrings.confirmLogout,
              size: 18,
            ),
            Gap(15),
            CommonText.regular(
              LogOutStrings.confirmLogoutDes,
              size: 15,
              textAlign: TextAlign.center,
              color: isDarkMode
                  ? AppColors.bodyTextDarkColor
                  : AppColors.bodyTextColor,
            ),
            Gap(25),
            Row(
              children: [
                Expanded(
                  child: OutlineButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    label: LogOutStrings.stayHere,
                    borderSide: BorderSide(color: AppColors.primary500),
                    textColor: AppColors.primary500,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
                Gap(20),
                Expanded(
                  child: PrimaryButton(
                    onPressed: () {
                      context.push(AppRouteName.signInView);
                    },
                    label: ChangesPasswordStrings.changePassword,
                    textSize: 16,
                    textWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
