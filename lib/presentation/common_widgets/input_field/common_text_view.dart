import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonTextView extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? suffixIcon;
  final int? minLines;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final Function(String value)? onChange;

  const CommonTextView({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.autofillHints,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
    this.fieldKey,
    this.suffixIcon,
    required this.minLines,
    this.maxLines,
    this.readOnly = false,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    required this.maxLength,
    this.onChange,
  });

  @override
  State<CommonTextView> createState() => _CommonTextViewState();
}

class _CommonTextViewState extends State<CommonTextView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      maxLines: widget.maxLines ?? widget.minLines,
      minLines: widget.minLines,
      readOnly: widget.readOnly,
      inputFormatters: widget.inputFormatters,
      textCapitalization: widget.textCapitalization,
      maxLength: widget.maxLength ?? 100,
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      decoration: InputDecoration(
        counterText: "",
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.full,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.full,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.full,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: ShapeBorderRadius.full,
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: Get.find<ThemeController>().isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
        ),
      ),
      onChanged: widget.onChange,
    );
  }
}
