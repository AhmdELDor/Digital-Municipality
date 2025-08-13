import 'package:flutter/material.dart';

class AppColors {
  // Base
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  static const Color primary50 = Color(0xFFF0F7FE);
  static const Color primary100 = Color(0xFFDDECFC);
  static const Color primary200 = Color(0xFFC3DEFA);
  static const Color primary300 = Color(0xFF99CAF7);
  static const Color primary400 = Color(0xFF69ADF1);
  static const Color primary500 = Color(0xFF4A90EB);

  static const Color secondary40 = Color(0xFFFFF0C6);
  static const Color secondary50 = Color(0xFFFFFAEB);
  static const Color secondary100 = Color(0xFFFEF3C7);
  static const Color secondary200 = Color(0xFFFEE889);
  static const Color secondary300 = Color(0xFFFDD54C);
  static const Color secondary400 = Color(0xFFFFB120);
  static const Color secondary500 = Color(0xFFF98D07);

  static const Color success50 = Color(0xFFF0FDF5);
  static const Color success100 = Color(0xFFDCFCE8);
  static const Color success200 = Color(0xFFBBF7D1);
  static const Color success300 = Color(0xFF86EFAD);
  static const Color success400 = Color(0xFF4ADE80);
  static const Color success500 = Color(0xFF22C55E);
  static const Color success600 = Color(0xFF16A34A);

  static const Color warning100 = Color(0xFFFEF3C7);
  static const Color warning200 = Color(0xFFFEE889);
  static const Color warning300 = Color(0xFFFDD54C);
  static const Color warning400 = Color(0xFFFDC122);
  static const Color warning500 = Color(0xFFF59E08);

  static const Color error50 = Color(0xFFFEF2F2);
  static const Color error100 = Color(0xFFFEE2E2);
  static const Color error200 = Color(0xFFFECACA);
  static const Color error300 = Color(0xFFFCA5A5);
  static const Color error400 = Color(0xFFF87171);
  static const Color error500 = Color(0xFFEF4444);

  static const Color headingsColor = Color(0xFF1F2937);
  static const Color headingsLightColor = Color(0xFFE5E7EB);
  static const Color bodyTextColor = Color(0xFF6B7280);
  static const Color bodyTextDarkColor = Color(0xFF9CA3AF);///////////
  static const Color greyTextColor = Color(0xFFA7A7A7);
  static const Color greyTextDarkColor = Color(0xFF8F8F8F);

  static const Color mainBgColor = Color(0xFFF9FAFB);
  static const Color mainDarkBgColor = Color(0xFF21242B);
  static const Color cardBgColor = Color(0xFFEDF5FF);
  static const Color cardDarkBgColor = Color(0xFF1C1E25);
  static const Color cardDarkBg2Color = Color(0xFF1C1E27);
  static const Color greyBgColor = Color(0xFFF2F2F2);
  static const Color greyColor = Color(0xFFB7B7B7);
  static const Color greyDarkColor = Color(0xFF454957);

  static const Color grey100Color = Color(0xFF404040);
  static const Color grey200Color = Color(0xFF414651);
  static const Color grey300Color = Color(0xFFCECFD2);

  static const Color commonGradientColor = Color(0xFF5D9D79);
  static const Color blueGradientColor = Color(0xFF30B2CE);
  static const Color backgroundLight = Color(0xFFBFDBFE);
  static const Color lightPrimaryColor = Color(0xFF60A6FA);
  static const Color borderSecondaryColor = Color(0xFFE9EAEB);
  static const Color borderDarkSecondaryColor = Color(0xFF22262F);
  static const Color background100 = Color(0xFFDBEAFE);
  static const Color borderDisabledColor = Color(0xFFD5D7DA);
  static const Color appBarShadowColor = Color(0xFF0A0D12);

  static const Color lightBgColor = Color(0xFFFAFCFF);
  static const Color lightBorderColor = Color(0xFFF1F3F5);
  static const Color lightShadowColor = Color(0xFFFFEDEF);

  static const Color brand600 = Color(0xFF3172DF);
  static const Color brand700 = Color(0xFF285CCD);

  static const Color purple100 = Color(0xFFDECDFF);
  static const Color purple200 = Color(0xFFAC86F6);
  static const Color purple600 = Color(0xFF8E56FD);

  static const Color pink600 = Color(0xFFE22C3F);




}

class AppCommonGradient extends AppColors {
  static LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF9FAFB), Color(0xFFF0F7FE)],
  );
  static const LinearGradient splashGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF4A90EB), // #4A90EB
      Color(0xFF69ADF1), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient splashDarkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xFF1B2A50), // #4A90EB
      Color(0xFF274CA6), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient dividerOneGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      Color(0xFFB7B7B7), // #4A90EB
      Color(0xFFF3F8FD), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient dividerDarkOneGradient = LinearGradient(
    begin: Alignment.centerRight,
    end: Alignment.centerLeft,
    colors: [
      Color(0xFF878787), // #4A90EB
      Color(0xFFFFFFFF), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient dividerTwoGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFFB7B7B7), // #4A90EB
      Color(0xFFF3F8FD), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient dividerDarkTwoGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [
      Color(0xFF878787), // #4A90EB
      Color(0xFFFFFFFF), // #69ADF1
    ],
    stops: [-0.3255, 0.9999], // Simulate the CSS offset
  );
  static const LinearGradient mainBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFDDECFC), Color(0xFFF9FAFB)],
    stops: [0.0007, 0.183],
  );
  static const LinearGradient mainDarkBackgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xff1B2A50), Color(0xff21242B)],
    stops: [0.0007, 0.183],
  );
  static LinearGradient borderGradient = LinearGradient(
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
    colors: [Colors.white, Colors.white.withValues(alpha: 0.50)],
  );
}

class AppCommonShadow extends AppColors {
  static BoxDecoration commonBoxShadow = BoxDecoration(
    color: AppColors.lightBgColor,
    borderRadius: BorderRadius.circular(20),
    border: Border.all(color:AppColors.lightBorderColor,width: 1 ),
    boxShadow: [
      BoxShadow(
        color: AppColors.primary100.withValues(alpha: 0.50),
        blurRadius: 40,
        spreadRadius: 1,
        offset: Offset(6, 6),
      ),
    ],
  );
  static BoxDecoration commonDarkBoxShadow = BoxDecoration(
    color: AppColors.mainDarkBgColor,
    borderRadius: BorderRadius.circular(20),
   border: Border.all(color:AppColors.grey100Color,width: 1)
  );



  // static BoxDecoration commonMeetingDarkBoxShadow = BoxDecoration(
  //   color: AppColors.cardDarkBgColor,
  //   boxShadow: [
  //     BoxShadow(
  //       color: AppColors.black.withValues(alpha: 0.09),
  //       offset: Offset(-6, -6),
  //       blurRadius: 23,
  //     ),
  //   ],
  // );
}

Color hexToColor(String hex) {
  try {
    return Color(int.parse(hex.replaceFirst('#', '0xff')));
  } catch (e) {
    return Colors.grey;
  }
}
