part of 'reset_password_successfully_imports.dart';
class ResetPasswordSuccessfully extends StatefulWidget {
  const ResetPasswordSuccessfully({super.key});

  @override
  State<ResetPasswordSuccessfully> createState() => _ResetPasswordSuccessfullyState();
}

class _ResetPasswordSuccessfullyState extends State<ResetPasswordSuccessfully> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(CommonImageAssets.resetPasswordSuccessfully,height: 216,),
            Gap(60),
            CommonText.semiBold(
              ResetPasswordSuccessfullyStrings.passwordResetSuccessfully,
              size: 18,
              height: 1.0,
              letterSpacing: 0.0,
              textAlign: TextAlign.center,
            ),
            Gap(12),

            CommonText.regular(
              ResetPasswordSuccessfullyStrings.passwordResetSuccessfullyDes,
              size: 15,
              height: 1.0,
              letterSpacing: 0.0,
              textAlign: TextAlign.center,
              color: isDarkMode?AppColors.bodyTextDarkColor:AppColors.bodyTextColor,
            ),
            Gap(40),
            PrimaryButton(
              onPressed: () {
                context.go(AppRouteName.signInView);
              },
              label: AppCommonStrings.btnBackToLogIn,
            )
          ],

        ),
      ),
    );
  }
}
