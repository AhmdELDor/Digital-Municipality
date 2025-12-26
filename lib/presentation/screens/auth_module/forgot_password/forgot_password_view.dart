part of 'forgot_password_imports.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  State<ForgotPasswordView> createState() => _ForgotPasswordViewState();
}

class _ForgotPasswordViewState extends State<ForgotPasswordView> {
  ForgotPasswordController controller = Get.put(ForgotPasswordController());
  @override
  Widget build(BuildContext context) {
   // var mobileView = ResponsiveView.isMobile(context);
    return Scaffold(
      appBar: CommonAppbar(),
      body: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            authBackgroundImageView(context),
            authSpaceView(context),
            Expanded(
              flex: 4,
              child: SingleChildScrollView(
                child: forgotPasswordView(),
              ),
            ),
            authSpaceView(context),
          ],
        ),
      ),
    );
  }

  Widget forgotPasswordView() {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    var mobileView = ResponsiveView.isMobile(context);
    return Column(
      //mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.center,
          child: SvgImageFromAsset(CommonImageAssets.appLogo),
        ),
        Gap(30),
        Container(
          decoration: mobileView?null:isDarkMode?AppCommonShadow.commonDarkBoxShadow:AppCommonShadow.commonBoxShadow,
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                authTitleHeader(ForgotPasswordStrings.forgotPasswordTitle),
                Gap(10),
                authSubTitleHeader(ForgotPasswordStrings.forgotPasswordDes),
                Gap(36),
                authHeader(SignInStrings.phoneNumber),
                Gap(10),
                CommonMobileField(
                  controller: controller.phoneController,
                  focusNode: controller.phoneFocus,
                  textInputAction: TextInputAction.done,
                  onChanged: (phoneNumber) {
                    controller.completePhoneNumber.value = phoneNumber.completeNumber;
                  },
                ),

                Gap(35),
                Obx(() {
                  return controller.isLoading.value
                      ? const Center(child: CommonCircularLoader())
                      : PrimaryButton(
                          onPressed: () {
                            controller.submit(context);
                          },
                          label: ForgotPasswordStrings.sendCode,
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
