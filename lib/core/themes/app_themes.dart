import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../presentation/app/theme_controller.dart';
import '../constants/app_colors.dart';
import 'app_color_extension.dart';
import 'app_size.dart';

abstract class AppTheme {
  static const defaultFontFamily = "Archivo";
  static const double letterSpacing = 0.3;
  static const double letterHeight = 1.5;

  static const ColorScheme _lightColorScheme = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary500,
    onPrimary: AppColors.white,
    secondary: AppColors.secondary500,
    onSecondary: AppColors.headingsColor,
    secondaryContainer: AppColors.secondary500,
    onSecondaryContainer: Colors.red,
    surface: AppColors.white,
    onSurface: AppColors.white,

    surfaceContainerHighest: Colors.yellow,
    onSurfaceVariant: AppColors.headingsColor,
    outline: Colors.transparent,
    inverseSurface: Colors.purpleAccent,
    onInverseSurface: Colors.purpleAccent,
    inversePrimary: AppColors.primary100,
    //shadow: AppColors.black,
    shadow: Colors.transparent,
    surfaceTint: AppColors.primary300,
    error: AppColors.error500,
    onError: AppColors.error500,
  );

  static final ColorScheme _darkColorScheme = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColors.primary500,
    onPrimary: AppColors.black,
    primaryContainer: AppColors.primary500,
    secondary: AppColors.secondary500,
    onSecondary: AppColors.headingsLightColor,
    secondaryContainer: AppColors.secondary500,
    onSecondaryContainer: AppColors.white,
    error: AppColors.error500,
    onError: AppColors.black,
    errorContainer: AppColors.error500,
    onErrorContainer: AppColors.white,
    surface: AppColors.mainDarkBgColor,
    onSurface: AppColors.mainDarkBgColor,
    surfaceContainerHighest: Colors.pink,
    onSurfaceVariant: AppColors.white,
    outline: Colors.brown,
    inverseSurface: Colors.red,
    onInverseSurface: Colors.red,
    inversePrimary: AppColors.primary100,
    shadow: AppColors.black,
    surfaceTint: AppColors.primary300,
  );

  static const AppColorTheme _appLightColorTheme = AppColorTheme(
    failure: AppColors.error500,
    failureLight: AppColors.error100,
    success: AppColors.success500,
    successLight: AppColors.success100,
  );

  static const AppColorTheme _appDarkColorTheme = AppColorTheme(
    failure: AppColors.error400,
    failureLight: AppColors.error200,
    success: AppColors.success400,
    successLight: AppColors.success200,
  );

  static ThemeData get lightTheme {
    const colorScheme = _lightColorScheme;
    return ThemeData(
      useMaterial3: true,
      primaryColor: colorScheme.primary,
      primaryColorDark: colorScheme.primary,
      primaryColorLight: colorScheme.primary,
      disabledColor: colorScheme.onSurface,
      shadowColor: colorScheme.shadow,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: defaultFontFamily,
      colorScheme: colorScheme,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      bottomSheetTheme: bottomSheetTheme(colorScheme),
      // dialogTheme: dialogTheme(colorScheme),
      // cardTheme: cardTheme(colorScheme),
      appBarTheme: appBarTheme(colorScheme),
      elevatedButtonTheme: elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: outlinedButtonTheme(colorScheme),
      textButtonTheme: textButtonTheme(colorScheme),
      textSelectionTheme: textSelectionTheme(colorScheme),
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      checkboxTheme: checkBoxTheme(colorScheme),
      snackBarTheme: snackBarTheme(colorScheme),
      //tabBarTheme: tabBarTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: popupMenuTheme(colorScheme),
      bottomAppBarTheme: bottomAppBarTheme(colorScheme),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colorScheme),
      datePickerTheme: datePickerThemeData(colorScheme),
      textTheme: textThemeData(colorScheme),
      extensions: const [_appLightColorTheme], tabBarTheme: TabBarThemeData(indicatorColor: colorScheme.primary),
    );
  }

  static ThemeData get darkTheme {
    var colorScheme = _darkColorScheme;
    return ThemeData(
      useMaterial3: true,
      primaryColor: colorScheme.primary,
      primaryColorDark: colorScheme.primary,
      primaryColorLight: colorScheme.primary,
      disabledColor: colorScheme.onSurface,
      shadowColor: colorScheme.shadow,
      scaffoldBackgroundColor: colorScheme.surface,
      fontFamily: defaultFontFamily,
      colorScheme: colorScheme,
      splashColor: Colors.transparent,
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      bottomSheetTheme: bottomSheetTheme(colorScheme),
      // dialogTheme: dialogTheme(colorScheme),
      // cardTheme: cardTheme(colorScheme),
      appBarTheme: appBarTheme(colorScheme),
      elevatedButtonTheme: elevatedButtonTheme(colorScheme),
      outlinedButtonTheme: outlinedButtonTheme(colorScheme),
      textButtonTheme: textButtonTheme(colorScheme),
      textSelectionTheme: textSelectionTheme(colorScheme),
      inputDecorationTheme: inputDecorationTheme(colorScheme),
      checkboxTheme: checkBoxTheme(colorScheme),
      snackBarTheme: snackBarTheme(colorScheme),
      // tabBarTheme: tabBarTheme(colorScheme),
      dividerTheme: DividerThemeData(
        color: colorScheme.outline,
        thickness: 1,
        space: 1,
      ),
      popupMenuTheme: popupMenuTheme(colorScheme),
      bottomAppBarTheme: bottomAppBarTheme(colorScheme),
      bottomNavigationBarTheme: bottomNavigationBarTheme(colorScheme),
      datePickerTheme: datePickerThemeData(colorScheme),
      textTheme: textThemeData(colorScheme),
      extensions: const [_appDarkColorTheme], tabBarTheme: TabBarThemeData(indicatorColor: colorScheme.primary),
    );
  }

  static AppBarTheme appBarTheme(ColorScheme colorScheme) {
    return AppBarTheme(
      toolbarHeight: 50,
      backgroundColor: colorScheme.surface,
      foregroundColor: colorScheme.surface,
      titleSpacing: 0,
      // elevation: 8,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarBrightness:
        colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
        statusBarIconBrightness:
        colorScheme.brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark,
      ),
      surfaceTintColor: colorScheme.surface,
      scrolledUnderElevation: 0,
      iconTheme: IconThemeData(
        color: colorScheme.onSurface, //change your color here
      ),
      titleTextStyle: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        fontFamily: defaultFontFamily,
        color: colorScheme.onSurface,
      ),
    );
  }

  static BottomAppBarThemeData bottomAppBarTheme(ColorScheme colorScheme) {
    return BottomAppBarThemeData(color: colorScheme.onSurface, elevation: 8);
  }
  static BottomNavigationBarThemeData bottomNavigationBarTheme(
    ColorScheme colorScheme,
  ) {
    var textStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      height: 2,
      color: colorScheme.primary,
    );
    return BottomNavigationBarThemeData(
      backgroundColor: colorScheme.onSurface,
      elevation: 0,
      landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
      type: BottomNavigationBarType.fixed,
      selectedLabelStyle: textStyle.copyWith(),
      unselectedLabelStyle: textStyle.copyWith(),
      selectedItemColor: colorScheme.primary,
      unselectedItemColor: Colors.grey.shade500,
    );
  }

  static CardTheme cardTheme(ColorScheme colorScheme) {
    return CardTheme(

      shape: const RoundedRectangleBorder(borderRadius: ShapeBorderRadius.full),
      margin: EdgeInsets.zero,
      color: colorScheme.surface,
      shadowColor: colorScheme.shadow,
      surfaceTintColor: colorScheme.surface,
      elevation: 0,
      clipBehavior: Clip.hardEdge,

    );
  }

  static DialogTheme dialogTheme(ColorScheme colorScheme) {
    return DialogTheme(
      insetPadding: EdgeInsets.symmetric(horizontal: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      backgroundColor: colorScheme.surface,
      elevation: 0,
      titleTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        fontFamily: defaultFontFamily,
      ),
      contentTextStyle: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        fontFamily: defaultFontFamily,
      ),
    );
  }

  static BottomSheetThemeData bottomSheetTheme(ColorScheme colorScheme) {
    return BottomSheetThemeData(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: ShapeRadius.xLarge2),
      ),
      backgroundColor: colorScheme.onSurface,
      elevation: 0,
      clipBehavior: Clip.hardEdge,
      showDragHandle: true,
    );
  }

  static TextSelectionThemeData textSelectionTheme(ColorScheme colorScheme) {
    return TextSelectionThemeData(
      cursorColor: AppColors.primary500,
      selectionColor: AppColors.primary500.withValues(alpha: 0.3),
      selectionHandleColor: AppColors.primary500,


        // selectionColor: primary300,
        // cursorColor: primary600,
        // selectionHandleColor: primary600

    );
  }

  static ElevatedButtonThemeData elevatedButtonTheme(ColorScheme colorScheme) {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colorScheme.primary,
        foregroundColor: colorScheme.onPrimary,
        shape: const RoundedRectangleBorder(
          borderRadius: ShapeBorderRadius.xLarge,
        ),
        elevation: 0,
        padding: const EdgeInsets.all(16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: defaultFontFamily,
        ),
      ),
    );
  }

  static OutlinedButtonThemeData outlinedButtonTheme(ColorScheme colorScheme) {
    return OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        shape: const RoundedRectangleBorder(
          borderRadius: ShapeBorderRadius.xLarge,
        ),
        padding: const EdgeInsets.all(16),
        side: BorderSide(color: colorScheme.tertiaryContainer, width: 1),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          fontFamily: defaultFontFamily,
        ),
      ),
    );
  }

  static TextButtonThemeData textButtonTheme(ColorScheme colorScheme) {
    return TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: colorScheme.primary,
        padding: PaddingValue.small,
        shape: const RoundedRectangleBorder(
          borderRadius: ShapeBorderRadius.xLarge,
        ),
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: defaultFontFamily,
        ),
      ),
    );
  }

  static InputDecorationTheme inputDecorationTheme(ColorScheme colorScheme) {
    const border = BorderSide.none;
    return InputDecorationTheme(
      labelStyle: TextStyle(color: AppColors.greyColor, fontSize: 12),
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      focusedErrorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error),
        borderRadius: ShapeBorderRadius.full,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: ShapeBorderRadius.full,
        // borderSide: BorderSide(
        //   color:
        //       Get.find<ThemeController>().isDarkMode
        //           ? AppColors.greyscale500
        //           : AppColors.greyscale300,
        //   width: 1,
        // ),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.error),
        borderRadius: ShapeBorderRadius.full,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: colorScheme.primary),
        borderRadius: ShapeBorderRadius.full,
      ),
      fillColor: colorScheme.surface,
      errorStyle: TextStyle(color: colorScheme.error),

      //hintStyle: TextStyle(color: AppColors.greyscale400, fontSize: 12),
      errorMaxLines: 100,
      border: OutlineInputBorder(
        borderRadius: ShapeBorderRadius.full,
        borderSide: border,
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: ShapeBorderRadius.full,
        borderSide: border,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 18),
      isDense: true,
      filled: true,
    );
  }

  static CheckboxThemeData checkBoxTheme(ColorScheme colorScheme) {
    return CheckboxThemeData(
      splashRadius: 0,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      checkColor: WidgetStatePropertyAll(AppColors.white),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      side: BorderSide(
        width: 1,
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.grey100Color
            : AppColors.greyColor,
      ),
    );
  }

  static SnackBarThemeData snackBarTheme(ColorScheme colorScheme) {
    return SnackBarThemeData(
      backgroundColor: colorScheme.primary,
      contentTextStyle: TextStyle(
        color: colorScheme.onPrimary,
        fontSize: 14,
        fontFamily: defaultFontFamily,
        fontWeight: FontWeight.w500,
      ),
      shape: const RoundedRectangleBorder(
        borderRadius: ShapeBorderRadius.small,
      ),
      behavior: SnackBarBehavior.floating,
      elevation: 8,
      actionTextColor: colorScheme.secondary,
      disabledActionTextColor: colorScheme.onSurface,
    );
  }

  static TabBarTheme tabBarTheme(ColorScheme colorScheme) {
    var labelStyle = TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      fontFamily: defaultFontFamily,
      color: colorScheme.onSecondary,
    );
    return TabBarTheme(
      labelStyle: labelStyle,
      unselectedLabelStyle: labelStyle.copyWith(fontWeight: FontWeight.w500),
      labelColor: colorScheme.onSecondary,
      unselectedLabelColor: colorScheme.onSurface,
      labelPadding: const EdgeInsets.symmetric(horizontal: 4),
    );
  }

  static DividerThemeData dividerTheme(ColorScheme colorScheme) {
    return DividerThemeData(color: colorScheme.outline, thickness: 1, space: 1);
  }

  static PopupMenuThemeData popupMenuTheme(ColorScheme colorScheme) {
    return PopupMenuThemeData(
      color: colorScheme.onSurface,
      shape: const RoundedRectangleBorder(
        borderRadius: ShapeBorderRadius.medium,
      ),
      elevation: 4,
      textStyle: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 14,
        fontFamily: defaultFontFamily,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  static DatePickerThemeData datePickerThemeData(ColorScheme colorScheme) {
    return DatePickerThemeData(
      elevation: 0,
      backgroundColor: colorScheme.onSurface,
    );
  }

  static TextTheme textThemeData(ColorScheme colorScheme) {
    return TextTheme(
      displayLarge: TextStyle(color: colorScheme.onSecondary, fontSize: 57.0),
      displayMedium: TextStyle(color: colorScheme.onSecondary, fontSize: 45.0),
      displaySmall: TextStyle(color: colorScheme.onSecondary, fontSize: 36.0),
      headlineLarge: TextStyle(color: colorScheme.onSecondary, fontSize: 32.0),
      headlineMedium: TextStyle(color: colorScheme.onSecondary, fontSize: 28.0),
      headlineSmall: TextStyle(color: colorScheme.onSecondary, fontSize: 24.0),
      titleLarge: TextStyle(color: colorScheme.onSecondary, fontSize: 22.0),
      titleMedium: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 16.0,
        letterSpacing: 0.15,
      ),
      titleSmall: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 14.0,
        letterSpacing: 0.1,
      ),
      bodyLarge: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 16,
        letterSpacing: 0.15,
      ),
      bodyMedium: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 14,
        letterSpacing: 0.25,
      ),
      bodySmall: TextStyle(
        color: colorScheme.onSecondary,
        fontSize: 12,
        letterSpacing: 0.4,
      ),
    );
  }
}
