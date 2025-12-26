part of 'sign_in_imports.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  late final SignInController controller;

  @override
  void initState() {
    super.initState();
    // Remove any existing controller instance to ensure fresh state
    Get.delete<SignInController>(force: true);
    controller = Get.put(SignInController());
  }

  @override
  void dispose() {
    Get.delete<SignInController>();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
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
                    vertical: mobileView ? 20 : 40,
                  ),
                  child: buildSignInForm(),
                ),
              ),
            ),
            authSpaceView(context),
          ],
        ),
      ),
    );
  }

  Widget buildSignInForm() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
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
          decoration: mobileView
              ? null
              : isDarkMode
              ? AppCommonShadow.commonDarkBoxShadow
              : AppCommonShadow.commonBoxShadow,
          padding: mobileView
              ? null
              : const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                authTitleHeader(SignInStrings.signInToYourAccount),
                Gap(10),
                authSubTitleHeader(SignInStrings.signInToYourAccountDes),
                Gap(36),
                authHeader(SignInStrings.phoneNumber),
                Gap(10),
                CommonMobileField(
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocus,
                  textInputAction: TextInputAction.next,
                  onChanged: (phoneNumber) {
                    controller.completePhoneNumber.value = phoneNumber.completeNumber;
                  },
                ),

                Gap(25),
                authHeader(AppCommonStrings.password),
                Gap(10),
                CommonPasswordField(
                  labelText: AppCommonStrings.password,
                  autofillHints: const [AutofillHints.password],
                  controller: controller.passwordController,
                  focusNode: controller.passwordFocus,
                  textInputAction: TextInputAction.done,
                  validator: validatePassword,
                  hintText: SignInStrings.enterPassword,
                  onChange: (String? value) {},
                ),
                Gap(15),
                Row(
                  children: [
                    mobileView
                        ? Obx(
                            () => SizedBox(
                              height: 20,
                              width: 20,
                              child: Checkbox(
                                value: controller.isRememberMe.value,
                                onChanged: (value) {
                                  controller.isRememberMe.value = value!;
                                },
                              ),
                            ),
                          )
                        : SizedBox(),
                    Gap(5),
                    mobileView
                        ? authSubTitleHeader(SignInStrings.rememberMe)
                        : SizedBox(),
                    Spacer(),

                    InkWell(
                      onTap: () {
                        context.push(AppRouteName.forgotPasswordView);
                      },
                      child: CommonText.medium(
                        SignInStrings.forGotPassword,
                        size: 14,
                        height: 1.0,
                        letterSpacing: 0.0,
                        textAlign: TextAlign.center,
                        color: AppColors.error500,
                      ),
                    ),
                  ],
                ),
                Gap(30),
                Obx(() {
                  return controller.isLoading.value
                      ? const Center(child: CommonCircularLoader())
                      : PrimaryButton(
                          onPressed: () {
                            controller.submit(context);
                            //context.go(AppRouteName.dashboardView);
                          },
                          label: AppCommonStrings.btnSignIn,
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
