part of 'reset_password_view_imports.dart';

class ResetPasswordView extends StatefulWidget {
  const ResetPasswordView({super.key});

  @override
  State<ResetPasswordView> createState() => _ResetPasswordViewState();
}

class _ResetPasswordViewState extends State<ResetPasswordView> {
  ChangePasswordController controller = Get.put(ChangePasswordController());
  @override
  Widget build(BuildContext context) {
    const double horizontalSpacing = 20;
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
      appBar: CommonAppbar(),

      body: SafeArea(
        child: Row(
          children: [
            authBackgroundImageView(context),
            authSpaceView(context),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: mobileView ? 20 : 0.0,
                    vertical: mobileView ? 20 : 70,
                  ),
                  child: resetPasswordView(),
                ),
              ),
            ),
            authSpaceView(context),
          ],
        ),
      ),
    );
  }
  Widget resetPasswordView(){
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgImageFromAsset(CommonImageAssets.appLogo),
        ),
        Gap(30),
        Container(
          decoration: isDarkMode?AppCommonShadow.commonDarkBoxShadow:AppCommonShadow.commonBoxShadow,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                authTitleHeader(ResetPasswordStrings.resetYourPassword),
                Gap(10),
                authSubTitleHeader(ResetPasswordStrings.resetYourPasswordDes),
                Gap(36),


                authHeader(ResetPasswordStrings.newPassword),
                Gap(10),
                CommonPasswordField(
                  labelText: '',
                  autofillHints: const [AutofillHints.password],
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocus,
                  textInputAction: TextInputAction.next,
                  validator: validatePassword,
                  hintText: ResetPasswordStrings.enterNewPassword,
                  fillColor: Colors.transparent,
                  onChange: (String? value) {},
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).nextFocus();
                  },
                ),

                Gap(25),
                authHeader(ResetPasswordStrings.confirmNewPassword),
                Gap(10),
                CommonPasswordField(
                  autofillHints: const [AutofillHints.password],
                  controller: controller.confirmPasswordController,
                  focusNode: controller.confirmPasswordFocus,
                  textInputAction: TextInputAction.done,
                  hintText: ResetPasswordStrings.confirmNewPassword,
                  onChange: (String? value) {},
                  fillColor: Colors.transparent,
                  validator: (value) => validateConfirmPassword(
                    value,
                    controller.passwordController.text,
                  ),
                ),
                Gap(30),
                Obx(() {
                  return controller.isLoading.value
                      ? const Center(child: CommonCircularLoader())
                      : PrimaryButton(
                    onPressed: () {
                      controller.submit(context);
                    },
                    label: ResetPasswordStrings.resetPassword,
                  );
                }),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
