import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_themes.dart';
import '../../app/theme_controller.dart';

class CommonText extends StatelessWidget {
  final String text;
  final double size;
  final Color? color,decorationColor;
  final TextAlign? textAlign;
  final TextOverflow? overflow;
  final int? maxLines;
  final bool isItalic;
  final double? height;
  final double? letterSpacing;
  final FontWeight fontWeight;
  final TextDecoration? decoration;
  final String? fontFamily;

  const CommonText(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontWeight = FontWeight.w400,
    this.fontFamily,
    this.decoration,
    super.key, this.decorationColor,
  });

  const CommonText.extraBold(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    super.key, this.decorationColor,
  }) : fontWeight = FontWeight.w800;

  const CommonText.bold(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    super.key, this.decorationColor,
  }) : fontWeight = FontWeight.w700;

  const CommonText.semiBold(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    this.fontWeight = FontWeight.w600,
    super.key, this.decorationColor,
  });

  // }) : fontWeight = FontWeight.w600;

  const CommonText.medium(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    super.key, this.decorationColor,
  }) : fontWeight = FontWeight.w500;

  const CommonText.regular(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height = 1.5,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    this.fontWeight = FontWeight.w400,
    super.key, this.decorationColor,
    // }) : fontWeight = FontWeight.w400;
  });

  const CommonText.light(
    this.text, {
    this.size = 12,
    this.color,
    this.textAlign,
    this.overflow,
    this.maxLines,
    this.isItalic = false,
    this.height = 1.5,
    this.letterSpacing,
    this.fontFamily,
    this.decoration,
    super.key, this.decorationColor,
  }) : fontWeight = FontWeight.w300;

  @override
  Widget build(BuildContext context) {
    // final colorScheme = Theme.of(context).colorScheme;
    final defaultTextStyle = DefaultTextStyle.of(context);

    return Text(
      text,
      textAlign: textAlign,
      overflow: overflow,
      maxLines: maxLines,
      style: defaultTextStyle.style.copyWith(
        fontFamily: fontFamily ?? AppTheme.defaultFontFamily,
        color:
            color ??
            (Get.find<ThemeController>().isDarkMode
                ? AppColors.headingsLightColor
                : AppColors.headingsColor),
        fontSize: size,
        fontStyle: isItalic ? FontStyle.italic : null,
        fontWeight: fontWeight,
        height: height,
        letterSpacing: letterSpacing,
        decoration: decoration?? TextDecoration.none,
        inherit: true,
        textBaseline: TextBaseline.alphabetic,
        decorationColor: decorationColor??AppColors.white
      ),
    );
  }
}
