import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';
import 'input_field.dart';

const kEmailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

class CommonEmailField extends InputField {
  const CommonEmailField({
    super.key,
    super.fieldKey,
    super.controller,
    super.focusNode,
    super.validator,
    super.autofillHints,
    super.textInputAction,
    super.hintText,
    super.labelText,
  });

  @override
  InputFieldState<CommonEmailField> createState() => _CommonEmailFieldState();
}

class _CommonEmailFieldState extends InputFieldState<CommonEmailField> {
  @override
  void controllerListener() {
    isValid.value =
        RegExp(kEmailPattern).hasMatch(controller.text.trim()) &&
        widget.validator?.call(controller.text) == null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: widget.fieldKey,
      controller: controller,
      focusNode: widget.focusNode,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: widget.autofillHints,
      validator: widget.validator,
      keyboardType: TextInputType.emailAddress,
      textInputAction: widget.textInputAction,
      inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
      maxLength: 50,
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
        fillColor: widget.fillColor ?? Colors.transparent,
        errorStyle: TextStyle(color: Theme.of(context).colorScheme.error,fontWeight: FontWeight.w700),
        hintText: widget.hintText??SignInStrings.enterEmailId,
        hintStyle: TextStyle(
          color: Get.find<ThemeController>().isDarkMode
              ? AppColors.bodyTextDarkColor
              : AppColors.bodyTextColor,
          fontSize: 14,
          fontWeight: FontWeight.w400
        ),
        prefixIcon: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 20, right: 5, top: 15, bottom: 15),
                child: SvgImageFromAsset.square(
                  AppCommonIcon.emailIcon,
                  size: 20,
                  colorFilter: ColorFilter.mode(
                    Get.find<ThemeController>().isDarkMode
                        ? AppColors.bodyTextDarkColor
                        : AppColors.bodyTextColor,
                    BlendMode.srcIn,
                  ),
                ),

              ),
              Container(
                height: 24,
                width: 1,
                color: Get.find<ThemeController>().isDarkMode
                    ? AppColors.grey100Color
                    :AppColors.headingsLightColor,
              ),
              const Gap(5),
            ],
          ),
        ),
        // suffixIcon: Row(
        //   mainAxisSize: MainAxisSize.min,
        //   children: [
        //     ValueListenableBuilder<bool>(
        //       valueListenable: isValid,
        //       builder: (context, isValid, child) => AnimatedCrossFade(
        //         alignment: Alignment.center,
        //         crossFadeState: isValid
        //             ? CrossFadeState.showFirst
        //             : CrossFadeState.showSecond,
        //         firstChild: const Padding(
        //           padding: EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
        //           child: SvgImageFromAsset.square(
        //             AppCommonIcon.successIcon,
        //             size: 20,
        //           ),
        //         ),
        //         secondChild: const SizedBox.shrink(),
        //         duration: const Duration(milliseconds: 300),
        //       ),
        //     ),
        //   ],
        // ),
      ),
    );
  }
}
