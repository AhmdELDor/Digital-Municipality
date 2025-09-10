import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? labelText;
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? contentPadding;
  final Color? fillColor;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final VoidCallback? onTap;
  final Function(String value)? onChange;
  final ValueChanged<String>? onFieldSubmitted;
  final InputCounterWidgetBuilder? buildCounter;
  final BorderSide? borderSide;
  const CommonTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.autofillHints,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
    this.labelText,
    this.fieldKey,
    this.prefixIcon,
    this.borderRadius,
    this.suffixIcon,
    this.minLines,
    this.maxLines,
    this.readOnly = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLength,
    this.onChange,
    this.onTap,
    this.fillColor,
    this.contentPadding,
    this.onFieldSubmitted,
    this.buildCounter,
    this.borderSide,
  });

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter: widget.buildCounter,
      key: widget.fieldKey,

      controller: widget.controller,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines ?? 1,
      minLines: widget.minLines,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      maxLength: widget.maxLength ?? 100,
      onFieldSubmitted: widget.onFieldSubmitted,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      decoration: InputDecoration(
        contentPadding:
            widget.contentPadding ?? EdgeInsets.fromLTRB(15, 15, 15, 15),
        counterText: "",
        focusedErrorBorder: OutlineInputBorder(
          borderSide:
              widget.borderSide ??
              BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: widget.borderRadius ?? ShapeBorderRadius.small,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: widget.borderRadius ?? ShapeBorderRadius.small,
          borderSide:
              widget.borderSide ??
              BorderSide(
                color: Get.find<ThemeController>().isDarkMode
                    ? AppColors.grey100Color
                    : AppColors.headingsLightColor,
                width: 1,
              ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide:
              widget.borderSide ??
              BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: widget.borderRadius ?? ShapeBorderRadius.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide:
              widget.borderSide ??
              BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: widget.borderRadius ?? ShapeBorderRadius.small,
        ),
        //fillColor: widget.fillColor ?? Theme.of(context).colorScheme.surface,
        fillColor: widget.fillColor ?? Colors.transparent,
        errorStyle: TextStyle(
          color: Theme.of(context).colorScheme.error,
          fontWeight: FontWeight.w700,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Get.find<ThemeController>().isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.prefixIcon != null ? 30 : 5,
        ),
        prefixIcon: widget.prefixIcon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10,
                      right: 0,
                      top: 20,
                      bottom: 20,
                    ),
                    child: widget.prefixIcon,
                  ),
                  const Gap(5),
                  Container(
                    height: 24,
                    width: 1,
                    color: Get.find<ThemeController>().isDarkMode
                        ? AppColors.grey100Color
                        : AppColors.headingsLightColor,
                  ),
                  const Gap(5),
                ],
              )
            : SizedBox.shrink(),
        suffixIconConstraints: BoxConstraints(
          minWidth: widget.suffixIcon != null ? 30 : 5,
        ),
        suffixIcon: widget.suffixIcon != null
            ? SizedBox(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [widget.suffixIcon ?? const SizedBox.shrink()],
                ),
              )
            : const SizedBox.shrink(),
      ),
      onTap: widget.onTap,
      onChanged: widget.onChange,
    );
  }
}

commonInputDecoration(String hintText, BuildContext context) {
  return InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(15, 15, 15, 15),
    counterText: "",
    focusedErrorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      borderRadius: ShapeBorderRadius.small,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: ShapeBorderRadius.small,
      borderSide: BorderSide(
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.grey100Color
            : AppColors.headingsLightColor,
        width: 1,
      ),
    ),
    errorBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
      borderRadius: ShapeBorderRadius.small,
    ),
    focusedBorder: OutlineInputBorder(
      borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
      borderRadius: ShapeBorderRadius.small,
    ),
    //fillColor: widget.fillColor ?? Theme.of(context).colorScheme.surface,
    fillColor: Colors.transparent,
    errorStyle: TextStyle(
      color: Theme.of(context).colorScheme.error,
      fontWeight: FontWeight.w700,
    ),
    hintText: hintText,
    hintStyle: TextStyle(
      color: Get.find<ThemeController>().isDarkMode
          ? AppColors.bodyTextDarkColor
          : AppColors.bodyTextColor,
      fontSize: 14,
      fontWeight: FontWeight.w400,
    ),
  );
}
