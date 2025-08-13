import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:input_phone_filed/country_picker_dialog.dart';
import 'package:input_phone_filed/intl_phone_field.dart';
import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/themes/app_size.dart';
import '../../app/theme_controller.dart';
import '../widgets/image.dart';
// class CommonMobileField extends InputField {
//   final Country country;
//   final bool isPrefixEnable;
//   final ValueSetter<Country> onCountrySelected;
//
//   const CommonMobileField({
//     super.key,
//     super.fieldKey,
//     super.controller,
//     super.focusNode,
//     super.validator,
//     super.autofillHints,
//     super.textInputAction,
//     super.hintText,
//     super.labelText,
//     required this.country,
//     required this.onCountrySelected,
//     this.isPrefixEnable = false,
//   });
//
//   @override
//   InputFieldState<CommonMobileField> createState() =>
//       _CommonMobileNumberFieldState();
// }
//
// class _CommonMobileNumberFieldState extends InputFieldState<CommonMobileField> {
//   late Country _country;
//
//   @override
//   void initState() {
//     _country = widget.country;
//     super.initState();
//   }
//
//   @override
//   void didUpdateWidget(covariant CommonMobileField oldWidget) {
//     if (_country != widget.country) {
//       _country = widget.country;
//     }
//     super.didUpdateWidget(oldWidget);
//   }
//
//   void _onCountrySelected(Country country) {
//     widget.onCountrySelected(country);
//     setState(() => _country = country);
//   }
//
//   @override
//   void controllerListener() {
//     isValid.value = widget.validator?.call(controller.text) == null;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return TextFormField(
//       key: widget.fieldKey,
//       controller: controller,
//       focusNode: widget.focusNode,
//       autovalidateMode: AutovalidateMode.onUserInteraction,
//       autofillHints: widget.autofillHints,
//       validator: widget.validator,
//       keyboardType: TextInputType.phone,
//       inputFormatters: [
//         MobileNumberInputFormatter(_country.phoneDetail.maxLength),
//       ],
//       textInputAction: widget.textInputAction,
//       style: TextStyle(
//         fontWeight: FontWeight.w600,
//         fontSize: 14,
//
//         color: Get.find<ThemeController>().isDarkMode
//             ? AppColors.headingsDarkColor
//             : AppColors.headingsColor,
//       ),
//       decoration: InputDecoration(
//         focusedErrorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
//           borderRadius: ShapeBorderRadius.small,
//         ),
//         enabledBorder: OutlineInputBorder(
//           borderRadius: ShapeBorderRadius.small,
//           borderSide: BorderSide(
//             color: Get.find<ThemeController>().isDarkMode
//                 ? AppColors.grey100Color
//                 : AppColors.greyColor,
//             width: 1,
//           ),
//         ),
//         errorBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
//           borderRadius: ShapeBorderRadius.full,
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
//           borderRadius: ShapeBorderRadius.full,
//         ),
//         fillColor: Theme.of(context).colorScheme.surface,
//         errorStyle: TextStyle(
//           color: Theme.of(context).colorScheme.error,
//           fontWeight: FontWeight.w700,
//         ),
//         hintText: widget.hintText,
//         hintStyle: TextStyle(
//           color: Get.find<ThemeController>().isDarkMode
//               ? AppColors.bodyTextDarkColor
//               : AppColors.bodyTextColor,
//           fontSize: 14,
//           fontWeight: FontWeight.w400,
//         ),
//         prefixIcon: IgnorePointer(
//           ignoring: widget.isPrefixEnable,
//           child: CountryPicker(
//             country: _country,
//             onCountrySelected: _onCountrySelected,
//           ),
//         ),
//         suffixIcon: ValueListenableBuilder<bool>(
//           valueListenable: isValid,
//           builder: (context, isValid, child) => Visibility(
//             visible: isValid,
//             child: const Padding(
//               padding: EdgeInsets.all(12),
//               // child:
//               //     SvgImageFromAsset.square("", color: context.appColor.success),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// class MobileNumberInputFormatter extends TextInputFormatter {
//   final int maxLength;
//
//   MobileNumberInputFormatter(this.maxLength);
//
//   @override
//   TextEditingValue formatEditUpdate(
//     TextEditingValue oldValue,
//     TextEditingValue newValue,
//   ) {
//     if (newValue.text.replaceAll(" ", "").length > maxLength) return oldValue;
//     if (newValue.text.length > oldValue.text.length) {
//       if (int.tryParse(newValue.text.replaceAll(" ", "")) == null) {
//         return oldValue;
//       }
//       var newText = newValue.text.replaceAll(" ", "");
//       StringBuffer buffer = StringBuffer();
//       for (int index = 0; index < newText.length; index++) {
//         buffer.write(newText[index]);
//         if (index == 2 || index == 5 || index == 7) buffer.write(" ");
//       }
//       return TextEditingValue(
//         text: buffer.toString(),
//         selection: TextSelection.collapsed(offset: buffer.length),
//       );
//     } else {
//       var newText = newValue.text.trim();
//       return newValue.copyWith(
//         text: newText.trim(),
//         selection: TextSelection.collapsed(offset: newText.length),
//       );
//     }
//   }
// }
//
// class CountryPicker extends StatefulWidget {
//   final Country country;
//   final ValueSetter<Country>? onCountrySelected;
//
//   const CountryPicker({
//     super.key,
//     required this.country,
//     required this.onCountrySelected,
//   });
//
//   @override
//   State<CountryPicker> createState() => _CountryPickerState();
// }
//
// class _CountryPickerState extends State<CountryPicker>
//     implements AutofillClient {
//   @override
//   void didChangeDependencies() {
//     AutofillGroup.of(context).register(this);
//     super.didChangeDependencies();
//   }
//
//   @override
//   void dispose() {
//     // AutofillGroup.of(context).unregister(autofillId);
//     super.dispose();
//   }
//
//   @override
//   void autofill(TextEditingValue newEditingValue) {
//     final newCountryCode = newEditingValue.text;
//     try {
//       final country = CountryPickerHelper.getCountryByPhoneCode(newCountryCode);
//       widget.onCountrySelected?.call(country!);
//     } catch (error) {
//       debugPrint(error.toString());
//     }
//   }
//
//   @override
//   String get autofillId => 'CountryPicker-$hashCode';
//
//   @override
//   TextInputConfiguration get textInputConfiguration {
//     final List<String> autofillHints = [AutofillHints.countryCode];
//     final AutofillConfiguration autofillConfiguration = AutofillConfiguration(
//       uniqueIdentifier: autofillId,
//       autofillHints: autofillHints,
//       currentEditingValue: TextEditingValue.empty,
//       hintText: "Country Code",
//     );
//     return TextInputConfiguration(
//       inputType: TextInputType.number,
//       autofillConfiguration: autofillConfiguration,
//     );
//   }
//
//   Future<void> onCountryTap() async {
//     var country = await showCountryPicker(context: context);
//     if (country != null) widget.onCountrySelected?.call(country);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return Container(
//       padding: const EdgeInsetsDirectional.only(end: 12),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           InkWell(
//             borderRadius: BorderRadius.circular(8),
//             onTap: widget.onCountrySelected == null ? null : onCountryTap,
//             child: Padding(
//               padding: PaddingValue.medium,
//               child: Row(
//                 children: [
//                   const Gap(10),
//                   Material(
//                     elevation: 1,
//                     shadowColor: colorScheme.shadow,
//                     borderRadius: BorderRadius.circular(100),
//                     clipBehavior: Clip.hardEdge,
//                     child: Image.asset(
//                       CountryPickerHelper.getFlagImageAssetPath(
//                         widget.country.isoCode,
//                       ),
//                       height: 20,
//                       width: 20,
//                       fit: BoxFit.cover,
//                       package: "country_picker",
//                     ),
//                   ),
//                   const Gap(8),
//                   CommonText.semiBold(
//                     "+${widget.country.phoneDetail.code}",
//                     size: 14,
//                     color: Get.find<ThemeController>().isDarkMode
//                         ? AppColors.headingsDarkColor
//                         : AppColors.headingsColor,
//                   ),
//                   const Gap(8),
//                   SvgImageFromAsset(
//                     AppCommonIcon.arrowDownIcon,
//                     colorFilter: ColorFilter.mode(
//                       AppColors.greyColor,
//                       BlendMode.srcIn,
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           const SizedBox(height: 20, child: VerticalDivider()),
//         ],
//       ),
//     );
//   }
// }

class CommonMobileField extends StatefulWidget {
  final FocusNode focusNode;
  final String hintText;

  const CommonMobileField({
    super.key,
    required this.focusNode,
    required this.hintText,
  });

  @override
  State<CommonMobileField> createState() => _CommonMobileFieldState();
}

class _CommonMobileFieldState extends State<CommonMobileField> {
  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return IntlPhoneField(
      style: TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Get.find<ThemeController>().isDarkMode
            ? AppColors.headingsLightColor
            : AppColors.headingsColor,
      ),
      focusNode: widget.focusNode,
      pickerDialogStyle: PickerDialogStyle(
        countryCodeStyle: TextStyle(
          color: isDarkMode?AppColors.white:AppColors.headingsColor,
            fontSize: 12
        ),
        countryNameStyle: TextStyle(
            color: isDarkMode?AppColors.white:AppColors.headingsColor,
          fontSize: 12
        ),


      ),

      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        counter: SizedBox(),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).colorScheme.error),
          borderRadius: ShapeBorderRadius.small,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: ShapeBorderRadius.small,
          borderSide: BorderSide(
            color: Get.find<ThemeController>().isDarkMode
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
          borderSide: BorderSide(color: Theme.of(context).colorScheme.primary),
          borderRadius: ShapeBorderRadius.small,
        ),
        fillColor: Colors.transparent,
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
      ),
      languageCode: "en",
      onChanged: (phone) {
        if (kDebugMode) {
          print(phone.completeNumber);
        }
      },
      onCountryChanged: (country) {

      },
      dropdownIcon: SvgImageFromAsset(
        AppCommonIcon.arrowDownIcon,
        colorFilter: ColorFilter.mode(AppColors.greyColor, BlendMode.srcIn),
      ),
    );
  }
}
