import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonDatePicker extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final String? hintText;
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final DateTime? initialDate;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? currentDate;
  final void Function(String date) onDatePicked;
final EdgeInsetsGeometry? contentPadding;
  const CommonDatePicker({
    super.key,
    this.controller,
    this.focusNode,
    this.validator,
    this.autofillHints,
    this.hintText,
    this.fieldKey,
    this.prefixIcon,
    this.suffixIcon,
    this.readOnly = false,
    required this.onDatePicked,
    this.initialDate,
    this.firstDate,
    this.lastDate,
    this.currentDate, this.contentPadding,
  });

  @override
  State<CommonDatePicker> createState() => _CommonDatePickerState();
}

class _CommonDatePickerState extends State<CommonDatePicker> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return TextFormField(
      autocorrect: false,
      key: widget.fieldKey,
      controller: widget.controller,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      readOnly: true,
      style: TextStyle(
        color: isDarkMode
            ? AppColors.bodyTextDarkColor
            : AppColors.bodyTextColor,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      ),
      decoration: InputDecoration(
        contentPadding: widget.contentPadding??const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 12,
        ),
        filled: true,
        fillColor: isDarkMode?AppColors.mainDarkBgColor:AppColors.lightBgColor,
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
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
                ? AppColors.grey100Color
                : AppColors.lightBorderColor,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error, width: 1.5,),
          borderRadius: ShapeBorderRadius.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary, width: 1.5,),
          borderRadius: ShapeBorderRadius.small,
        ),
        //fillColor: Theme.of(context).colorScheme.surface,
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error,),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color: isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.prefixIcon != null ? 40 : 10,
        ),
        prefixIcon: (widget.prefixIcon?.isBlank ?? false)
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 10,
                      top: 20,
                      bottom: 20,
                    ),
                    child: widget.prefixIcon ?? const SizedBox.shrink(),
                  ),
                  const Gap(6),
                ],
              )
            : const SizedBox.shrink(),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [widget.suffixIcon ?? const SizedBox.shrink()],
        ),
      ),
      onSaved: (value) {},
      onTap: () {
        _selectDate(context);
        FocusScope.of(context).requestFocus(FocusNode());
      },
    );
  }

  Future _selectDate(BuildContext context) async {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate:
          widget.initialDate ??
          DateTime.now().subtract(const Duration(days: 18 * 365)),
      firstDate: widget.firstDate ?? DateTime(DateTime.now().year - 100),
      lastDate:
          widget.lastDate ??
          DateTime.now().subtract(const Duration(days: 18 * 365)),
      currentDate: widget.currentDate ?? DateTime.now(),
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light().copyWith(
              primary: AppColors.primary500,
              onSurface: isDarkMode ? AppColors.white : AppColors.headingsColor,
              onPrimary: AppColors.white,
            ),
            datePickerTheme: DatePickerThemeData(

              yearForegroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary500;
                }
                return isDarkMode ? AppColors.white : AppColors.headingsColor;
              }),
              yearBackgroundColor: WidgetStateProperty.resolveWith<Color>((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary500.withValues(alpha: 0.1);
                }
                return Colors.transparent;
              }),
              yearStyle: WidgetStateTextStyle.resolveWith((states) {
                return TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: states.contains(WidgetState.selected)
                      ? AppColors.primary500
                      : (isDarkMode ? AppColors.white : AppColors.headingsColor),
                );
              }),

              headerForegroundColor:
             isDarkMode ? AppColors.white : AppColors.headingsColor,
              surfaceTintColor: Colors.transparent,
              backgroundColor: isDarkMode ? AppColors.mainDarkBgColor : AppColors.lightBgColor,
              dividerColor: isDarkMode ? AppColors.grey100Color : AppColors.lightBorderColor
            ),

            inputDecorationTheme: InputDecorationTheme(
              hintStyle: TextStyle(
                  color:  isDarkMode ? AppColors.white : AppColors.headingsColor,),
              labelStyle: TextStyle(
                  color:  isDarkMode ? AppColors.white : AppColors.headingsColor,),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                    color:  isDarkMode ? AppColors.white : AppColors.headingsColor,),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: AppColors.primary500),
              ),
            ),
            textTheme: TextTheme(
              titleMedium: TextStyle(
                color:  isDarkMode ? AppColors.white : AppColors.headingsColor,
              ),
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary500, // year dropdown and buttons
              ),
            ),
            dividerColor:  isDarkMode ? AppColors.white : AppColors.headingsColor,
            dividerTheme: DividerThemeData(
              color:  isDarkMode ? AppColors.white : AppColors.headingsColor,
              thickness: 1.2,
            ),
          ),
          child: child!,
        );
        //   Theme(
        //
        //   data: ThemeData.light().copyWith(
        //     colorScheme: const ColorScheme.light().copyWith(
        //       primary: coffeePrimary, // Change the primary color
        //     ),
        //   ),
        //   child: child!,
        // );
      },
    );

    if (picked != null) {
      final formattedDate = DateFormat('dd MMMM yyyy').format(picked);
      widget.controller?.text = formattedDate; // ✅ display in field
      widget.onDatePicked(formattedDate); // ✅ callback for controller or logic
    }
  }
}
