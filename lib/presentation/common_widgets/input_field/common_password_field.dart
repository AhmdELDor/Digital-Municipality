import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../../core/themes/app_themes.dart';
import '../../app/theme_controller.dart';
import '../widgets/icon.dart';
import '../widgets/image.dart';
import '../widgets/validations.dart';
import 'input_field.dart';

class CommonPasswordField extends InputField {
  final Function(String? value) onChange;

  const CommonPasswordField({
    super.key,
    super.fieldKey,
    super.controller,
    super.focusNode,
    super.validator,
    super.autofillHints,
    super.textInputAction,
    super.hintText,
    super.labelText,
    super.onFieldSubmitted,
    super.fillColor,
    required this.onChange,
  });

  @override
  InputFieldState<InputField> createState() => _CommonPasswordFieldState();
}

class _CommonPasswordFieldState extends InputFieldState<CommonPasswordField> {
  final ValueNotifier<bool> _isPasswordVisible = ValueNotifier(false);

  @override
  void controllerListener() {
    isValid.value =
        passwordRegex.hasMatch(controller.text.trim()) &&
        widget.validator?.call(controller.text) == null;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: _isPasswordVisible,
      builder: (context, isPasswordVisible, child) {
        return TextFormField(

          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
          key: widget.fieldKey,
          controller: controller,
          focusNode: widget.focusNode,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          obscuringCharacter: "*",
          autofillHints: widget.autofillHints,
          validator: widget.validator,
          keyboardType: TextInputType.visiblePassword,
          obscureText: !isPasswordVisible,
          textInputAction: widget.textInputAction,
          maxLength: 30,
          onChanged: (value) => widget.onChange(value),
          onFieldSubmitted: widget.onFieldSubmitted,
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
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
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
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.error,
              ),
              borderRadius: ShapeBorderRadius.small,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.primary,
              ),
              borderRadius: ShapeBorderRadius.small,
            ),
            fillColor: widget.fillColor??Colors.transparent,
            errorStyle: TextStyle(
              color: Theme.of(context).colorScheme.error,
              fontFamily: AppTheme.defaultFontFamily,
              fontWeight: FontWeight.w700,
            ),
            hintText: widget.hintText,
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
                    padding: EdgeInsets.only(
                      left: 20,
                      right: 5,
                      top: 15,
                      bottom: 15,
                    ),
                    child: SvgImageFromAsset.square(
                      AppCommonIcon.passwordIcon,
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
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ActionIcon(
                  onPressed: () =>
                      _isPasswordVisible.value = !isPasswordVisible,
                  icon: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 12, 0, 12),
                    child: SvgImageFromAsset.square(
                      isPasswordVisible
                          ? AppCommonIcon.showPasswordIcon
                          : AppCommonIcon.hidePasswordIcon,
                      size: 20,
                      colorFilter: ColorFilter.mode(
                        Get.find<ThemeController>().isDarkMode
                            ? AppColors.bodyTextDarkColor
                            : AppColors.bodyTextColor,
                        BlendMode.srcIn,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
