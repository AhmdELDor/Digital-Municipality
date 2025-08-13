import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';

class CommonDateRangePicker extends StatefulWidget {
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final FormFieldValidator<String>? validator;
  final List<String>? autofillHints;
  final String? hintText;
  final GlobalKey<FormFieldState>? fieldKey;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool readOnly;
  final DateTimeRange? initialDateRange;
  final DateTime? firstDate;
  final DateTime? lastDate;
  final void Function(DateTimeRange date) onDatePicked;

  const CommonDateRangePicker({
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
    required this.initialDateRange,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<CommonDateRangePicker> createState() => _CommonDateRangePickerState();
}

class _CommonDateRangePickerState extends State<CommonDateRangePicker> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color:
        Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      decoration: InputDecoration(
        counterText: "",
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.small,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
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
          borderRadius: ShapeBorderRadius.small,
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color:
            Theme.of(context).colorScheme.primary,
          ),
          borderRadius: ShapeBorderRadius.small,
        ),
        fillColor:
        Theme.of(context).colorScheme.surface,
        errorStyle: TextStyle(
          color:
          Theme.of(context).colorScheme.error,
        ),
        hintText: widget.hintText,
        hintStyle: TextStyle(
          color:
              AppColors.bodyTextColor,
          fontSize: 14,
        ),
        prefixIconConstraints: BoxConstraints(
          minWidth: widget.prefixIcon != null ? 40 : 25,
        ),
        prefixIcon:
            (widget.prefixIcon?.isBlank ?? false)
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
        suffixIconConstraints: BoxConstraints(
          minWidth: widget.suffixIcon != null ? 40 : 25,
        ),
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
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: widget.firstDate ?? DateTime.now(),
      lastDate: widget.lastDate ?? DateTime.now(),
      initialDateRange: widget.initialDateRange,
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      builder: (BuildContext context, Widget? child) {
        return child!;
        // Theme(
        //   data:
        //       Get.find<ThemeController>().isDarkMode
        //           ? ThemeData.light().copyWith(
        //             appBarTheme: const AppBarTheme(
        //               backgroundColor: Colors.transparent,
        //               systemOverlayStyle: SystemUiOverlayStyle(
        //                 statusBarColor: Colors.transparent,
        //                 statusBarBrightness: Brightness.light,
        //                 statusBarIconBrightness: Brightness.dark,
        //               ),
        //             ),
        //             colorScheme: ColorScheme.light(
        //               onPrimary: Colors.white, // selected text color
        //               onSurface:
        //                   AppColors.appPrimaryColor, // default text color
        //               primary: AppColors.appPrimaryColor, // circle color
        //               secondary: AppColors.appSecondaryColor.withValues(
        //                 alpha: 0.2,
        //               ),
        //               onSecondary: Colors.red,
        //               onPrimaryContainer: Colors.white,
        //               onPrimaryFixed: Colors.white,
        //             ),
        //           )
        //           : ThemeData.dark().copyWith(
        //             appBarTheme: const AppBarTheme(
        //               backgroundColor: Colors.transparent,
        //               systemOverlayStyle: SystemUiOverlayStyle(
        //                 statusBarColor: Colors.transparent,
        //                 statusBarBrightness: Brightness.light,
        //                 statusBarIconBrightness: Brightness.dark,
        //               ),
        //             ),
        //             colorScheme: ColorScheme.dark(
        //               onPrimary: Colors.white, // selected text color
        //               onSurface:
        //                   AppColors.appPrimaryColor, // default text color
        //               primary: AppColors.appPrimaryColor, // circle color
        //               secondary: AppColors.appSecondaryColor.withValues(
        //                 alpha: 0.2,
        //               ),
        //               onSecondary: Colors.red,
        //               onPrimaryContainer: Colors.white,
        //               onPrimaryFixed: Colors.white,
        //             ),
        //           ),
        //   child: child!,
        // );
      },
    );

    // DateTime? picked = await showDatePicker(
    //   context: context,
    //   initialDate: widget.initialDate ??
    //       DateTime.now().subtract(const Duration(days: 18 * 365)),
    //   firstDate: widget.firstDate ?? DateTime(DateTime.now().year - 100),
    //   lastDate: widget.lastDate ??
    //       DateTime.now().subtract(const Duration(days: 18 * 365)),
    //   currentDate: widget.currentDate ?? DateTime.now(),
    //   initialEntryMode: DatePickerEntryMode.calendarOnly,
    // );

    if (picked != null) {
      widget.onDatePicked(picked);
    }
  }
}
