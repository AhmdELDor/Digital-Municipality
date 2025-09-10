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


class CommonMobileField extends StatefulWidget {
  // final FocusNode focusNode;
  final String hintText;

  const CommonMobileField({
    super.key,
    //required this.focusNode,
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
      //focusNode: widget.focusNode,
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
