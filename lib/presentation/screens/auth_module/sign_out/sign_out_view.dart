part of 'sign_out_imports.dart';

class SignOutView extends StatefulWidget {
  const SignOutView({super.key});

  @override
  State<SignOutView> createState() => _SignOutViewState();
}

class _SignOutViewState extends State<SignOutView> {
  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: commonCloseIcon(context),
          ),
          Gap(20),
          SvgImageFromAsset(CommonImageAssets.logOutImg, height: 48, width: 48),
          Gap(20),
          CommonText.medium(LogOutStrings.confirmLogout, size: 18),
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
                  label: LogOutStrings.signOut,
                  textSize: 16,
                  textWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
