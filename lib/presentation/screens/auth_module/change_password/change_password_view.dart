part of 'change_password_view_imports.dart';

class ChangePasswordView extends StatefulWidget {
  const ChangePasswordView({super.key});

  @override
  State<ChangePasswordView> createState() => _ChangePasswordViewState();
}

class _ChangePasswordViewState extends State<ChangePasswordView> {
  ChangePasswordController controller = Get.put(ChangePasswordController());
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: controller.formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CommonText.semiBold(
                    ChangesPasswordStrings.changePassword,
                    size: 18,
                  ),
                  commonCloseIcon(context),
                ],
              ),
            ),

            CommonDivider(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gap(15),
                  authHeader(
                    ChangesPasswordStrings.currentPassword,

                  ),
                  Gap(10),
                  CommonPasswordField(
                    labelText: '',
                    autofillHints: const [AutofillHints.password],
                    controller: controller.currentPasswordController,
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
                  authHeader(ChangesPasswordStrings.newPassword, ),
                  Gap(10),
                  CommonPasswordField(
                    labelText: '',
                    autofillHints: const [AutofillHints.password],
                    controller: controller.newPasswordController,

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
                  authHeader(
                    ChangesPasswordStrings.confirmPassword,

                  ),
                  Gap(10),
                  CommonPasswordField(
                    autofillHints: const [AutofillHints.password],
                    controller: controller.confirmPasswordController,
                    textInputAction: TextInputAction.done,
                    hintText: ChangesPasswordStrings.confirmPassword,
                    onChange: (String? value) {},
                    fillColor: Colors.transparent,
                    validator: (value) => validateConfirmPassword(
                      value,
                      controller.newPasswordController.text,
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
                          textSize: 15,
                          textWeight: FontWeight.w500,
                        ),
                      ),
                      Gap(15),
                      Expanded(
                        child: PrimaryButton(
                          onPressed: () {
                            final isValid = controller.formKey.currentState!
                                .validate();
                            Get.focusScope!.unfocus();

                            if (!isValid) return;

                            controller.formKey.currentState!.save();

                            Navigator.pop(context);
                          },
                          label: ChangesPasswordStrings.changePassword,
                          textSize: 15,
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
