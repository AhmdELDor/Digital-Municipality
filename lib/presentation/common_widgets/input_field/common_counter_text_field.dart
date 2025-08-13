import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonCounterTextField extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final TextInputAction? textInputAction;
  final TextInputType? keyboardType;
  final String? hintText;
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
  final  ValueChanged<String>? onFieldSubmitted;
 final InputCounterWidgetBuilder? buildCounter;
  const CommonCounterTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.autofillHints,
    this.textInputAction,
    this.keyboardType,
    this.hintText,
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
  });

  @override
  State<CommonCounterTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonCounterTextField> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      buildCounter:widget.buildCounter ,
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
        color:
        Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      decoration: InputDecoration(
        contentPadding:
            widget.contentPadding ?? EdgeInsets.fromLTRB(12, 12, 12, 16),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius:widget.borderRadius?? ShapeBorderRadius.full,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius:widget.borderRadius??  ShapeBorderRadius.full,
          borderSide: BorderSide(
            color:
            Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.greyColor,
            width: 1,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius:widget.borderRadius??  ShapeBorderRadius.full,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius:widget.borderRadius??  ShapeBorderRadius.full,
        ),
        fillColor: Theme.of(context).colorScheme.surface,
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error),
        hintText: widget.hintText,
        hintStyle: TextStyle(color: AppColors.bodyTextColor, fontSize: 14),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.prefixIcon != null ? 30 : 20,
        ),
        prefixIcon:
            widget.prefixIcon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 0,
                        top: 20,
                        bottom: 20,
                      ),
                      child: widget.prefixIcon,
                    ),
                    const Gap(6),
                  ],
                )
                : const SizedBox.shrink(),
        suffixIconConstraints: BoxConstraints(
          minWidth: widget.suffixIcon != null ? 30 : 5,
        ),
        suffixIcon:
            widget.suffixIcon != null
                ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [widget.suffixIcon ?? const SizedBox.shrink()],
                )
                : const SizedBox.shrink(),
      ),
      onTap: widget.onTap,
      onChanged: widget.onChange,
    );
  }
}
