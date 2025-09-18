part of 'otp_verification_imports.dart';

class OtpVerificationView extends StatefulWidget {
  const OtpVerificationView({super.key});

  @override
  State<OtpVerificationView> createState() => _OtpVerificationViewState();
}

class _OtpVerificationViewState extends State<OtpVerificationView> {
  @override
  void initState() {
    super.initState();
    controller.startTimer();
  }

  @override
  void dispose() {
    controller.timer?.cancel();
    super.dispose();
  }

  OtpVerificationController controller = Get.put(OtpVerificationController());
  @override
  Widget build(BuildContext context) {

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
                  child: otpVerifyView(),
                ),
              ),
            ),
            authSpaceView(context),
          ],
        ),
      ),
    );
  }
  Widget otpVerifyView(){
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
          decoration:mobileView?null: isDarkMode?AppCommonShadow.commonDarkBoxShadow:AppCommonShadow.commonBoxShadow,
          padding:  EdgeInsets.symmetric(horizontal: mobileView?5:25, vertical: 25),
          child: Form(
            key: controller.formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               authTitleHeader(
                 OtpVerificationStrings.otpVerifyTitle,
               ),
               Gap(10),
               authSubTitleHeader(OtpVerificationStrings.otpVerifyDes),
               Gap(40),
               Align(
                 alignment: Alignment.center,
                 child: CommonOtpField(
                   controller: controller.otpController,
                   focusNode: controller.otpFocus,
                   length: 6,

                   onChanged: (value) {
                     controller.isOTPValidate.value =
                     (value.length == 4);
                   },
                   onCompleted: (_) {},
                 ),
               ),
               Gap(40),

               Obx(() {
                 return Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     CommonText.medium(
                       controller.second.value == 0
                           ? OtpVerificationStrings.didNotReceiveCode
                           : OtpVerificationStrings.didNotReceiveCode,
                       size: 15,
                     ),
                     Gap(3),
                     InkWell(
                       onTap: () {
                         controller.second.value == 0
                             ? controller.resendCode(context)
                             : null;
                       },
                       child: CommonText.medium(
                         controller.second.value == 0
                             ? OtpVerificationStrings.resend
                             : "${controller.second.value}'s",
                         size: 15,
                         color: AppColors.primary500,
                       ),
                     ),
                   ],
                 );
               }),
               Gap(15),
               Obx(() {
                 return controller.isLoading.value
                     ? const Center(child: CommonCircularLoader())
                     : PrimaryButton(
                   onPressed: () {
                     controller.submit(context);
                   },
                   label: OtpVerificationStrings.verifyEmail,
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
