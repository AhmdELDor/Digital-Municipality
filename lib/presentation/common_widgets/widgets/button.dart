import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../app/theme_controller.dart';
import 'device_info.dart';

class BottomPersistenceButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? textColor;
  final double? height;
  final double? width;
  final double? textSize;
  final FontWeight? textWeight;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool transparent;
  final bool isLoading;

  const BottomPersistenceButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.transparent = true,
    this.backgroundColor,
    this.foregroundColor,
    this.isLoading = false,
    this.textColor,
    this.height,
    this.width,
    this.textSize,
    this.textWeight,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    Widget child = SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: IntrinsicHeight(
        child: _Button(
          label: label,
          onPressed: onPressed,
          backgroundColor: backgroundColor ?? colorScheme.primary,
          foregroundColor: colorScheme.onPrimary,
          textColor: textColor,
          isLoading: isLoading,
          height: height,
          width: width,
          textSize: textSize,
          textWeight: textWeight,
        ),
      ),
    );

    if (!transparent) {
      final theme = Theme.of(context);
      final bottomAppBarTheme = theme.bottomAppBarTheme;
      child = Material(
        color: bottomAppBarTheme.color,
        shadowColor: theme.colorScheme.shadow,
        elevation: bottomAppBarTheme.elevation ?? 0,
        child: child,
      );
    }
    return child;
  }
}

class PrimaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? textColor;
  final Color? backgroundColor;
  final double? height;
  final double? width;
  final double? textSize;
  final double? borderRadius;
  final FontWeight? textWeight;
  final bool isLoading;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BorderSide? borderSide;
  final BoxDecoration? decoration;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.height,
    this.width,
    this.textColor,
    this.isLoading = false,
    this.textSize,
    this.textWeight,
    this.backgroundColor,
    this.prefixIcon,
    this.suffixIcon,
    this.borderRadius,
    this.borderSide,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _Button(
      label: label,
      onPressed: onPressed,
      backgroundColor: backgroundColor ?? colorScheme.primary,
      foregroundColor: colorScheme.onPrimary,
      textColor: textColor ?? AppColors.white,
      isLoading: isLoading,
      height: height??48,
      textSize: textSize,
      textWeight: textWeight,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      width: width,
      borderRadius: borderRadius??6,
      borderSide: borderSide,
      decoration: decoration,
    );
  }
}

class SecondaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? textColor;
  final double? height;
  final Widget? prefixIcon;

  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.textColor,
    this.height,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _Button(

      label: label,
      height: height,
      onPressed: onPressed,
      prefixIcon: prefixIcon,
      backgroundColor: colorScheme.secondary,
      foregroundColor: colorScheme.onSecondary,
      textColor: colorScheme.onSecondary,
      textSize: 16,
      borderSide: const BorderSide(color: Colors.transparent),
    );
  }
}

class OutlineButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? textColor;
  final double? height;
  final double? textSize;
  final FontWeight? textWeight;
  final BorderSide? borderSide;
  final double? borderRadius;

  const OutlineButton({
    super.key,
    required this.onPressed,
    required this.label,
    this.textColor,
    this.height,
    this.textSize,
    this.textWeight,
    this.borderSide,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return _Button(

      label: label,
      onPressed: onPressed,
      borderRadius: borderRadius??6,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.transparent,
      textColor:textColor??
          (Get.find<ThemeController>().isDarkMode
              ? AppColors.headingsLightColor
              : AppColors.headingsColor),
      textSize: textSize,
      textWeight: textWeight,
      borderSide:borderSide??  BorderSide(color:AppColors.greyColor),
      height: height??48,

    );
  }
}

class TertiaryButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const TertiaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _Button(
      label: label,
      onPressed: onPressed,
      backgroundColor: colorScheme.tertiaryContainer,
      foregroundColor: colorScheme.onTertiary,
    );
  }
}

class ErrorButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;

  const ErrorButton({super.key, required this.onPressed, required this.label});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _Button(
      label: label,
      onPressed: onPressed,
      backgroundColor: colorScheme.error,
      foregroundColor: colorScheme.onError,
      textColor: AppColors.white,
      borderRadius: 6,
    );
  }
}

enum ButtonState { init, loading, done }

class _Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final Color? textColor;
  final double? textSize;
  final FontWeight? textWeight;
  final double? height;
  final double? width;
  final double? borderRadius;
  final bool isLoading;
  final BorderSide? borderSide;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final BoxDecoration? decoration;

  const _Button({
    required this.onPressed,
    required this.label,
    this.backgroundColor,
    this.foregroundColor,
    this.textColor,
    this.height = 52,
    this.isLoading = false,
    this.textSize = 18,
    this.textWeight = FontWeight.w700,
    this.borderSide,
    this.prefixIcon,
    this.suffixIcon,
    this.width,
    this.borderRadius,
    this.decoration,
  });

  @override
  Widget build(BuildContext context) {
    double widgetWidth =
        isTablet(context)
            ? width ??
                context.width *
                    0.5 // Width for iPads/Tablets
            : context.width; // Width for iPhones/Phones

    return Center(
      child: AnimatedContainer(

        height: height ?? 52,
        width: isLoading ? height : widgetWidth,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
        decoration:
            decoration ??
            BoxDecoration(
              borderRadius: BorderRadius.circular(
                isLoading ? 52 : borderRadius ?? 100,
              ),
            ),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shadowColor: Colors.transparent,
            elevation: 0,
            disabledBackgroundColor: Colors.transparent,
            disabledForegroundColor: Colors.transparent,
            overlayColor: Colors.transparent,

            padding: EdgeInsets.zero,
            backgroundColor: backgroundColor,
            foregroundColor: foregroundColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                isLoading ? 54 : borderRadius ?? 100,
              ),
              side:
                  borderSide ??
                  const BorderSide(color: Colors.transparent, width: 1),
              // borderRadius: BorderRadius.circular(isLoading ? 60 : 8),
              // side: borderSide ?? const BorderSide(color: Colors.transparent),
            ),
          ),
          onPressed: isLoading ? () {} : onPressed,
          child:
              isLoading
                  ? const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  )
                  : Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      prefixIcon ?? const SizedBox.shrink(),
                      Gap(prefixIcon != null ? 5 : 0),
                      Flexible(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: textSize,
                            fontWeight: textWeight,
                          ),
                          softWrap: false,
                        ),
                      ),
                      Gap(suffixIcon != null ? 5 : 0),
                      suffixIcon ?? const SizedBox.shrink(),
                    ],
                  ),
        ),
      ),
    );
  }
}
