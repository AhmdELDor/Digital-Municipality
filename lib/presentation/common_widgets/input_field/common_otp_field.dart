import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import '../../../core/constants/app_colors.dart';
import '../../../utils/extensions/responsive.dart';
import '../../app/theme_controller.dart';

class CommonOtpField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final int length;
  final ValueChanged<String>? onChanged;
  final ValueSetter<String>? onCompleted;

  const CommonOtpField({
    super.key,
    required this.controller,
    required this.focusNode,
    required this.length,
    this.onChanged,
    this.onCompleted,
  });

  @override
  State<StatefulWidget> createState() => _CommonOtpFieldState();
}

class _CommonOtpFieldState extends State<CommonOtpField> {
  @override
  void initState() {

    super.initState();
  }

  @override
  void dispose() {

    super.dispose();
    // SmsAutoFill().unregisterListener();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    var mobileView = ResponsiveView.isMobile(context);
    bool isDarkMode = Get.find<ThemeController>().isDarkMode;
    return LayoutBuilder(
      builder: (context, constraints) {
        final pinTheme = PinTheme(
          width: 48,
          height: 48,
          margin: EdgeInsets.symmetric(horizontal: mobileView?5:12),
          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: colorScheme.primary, width: 1),
            color: colorScheme.surface,
          ),
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w500,
            color:
            AppColors.primary500,
          ),
        );

        return Pinput(


          controller: widget.controller,
          focusNode: widget.focusNode,
          autofocus: true,
          autofillHints: const [AutofillHints.oneTimeCode],
          pinAnimationType: PinAnimationType.scale,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          defaultPinTheme: pinTheme,
          followingPinTheme: pinTheme.copyDecorationWith(
            border: Border.all(
              color: isDarkMode?AppColors.grey100Color:AppColors.headingsLightColor,
              width: 1,
            ),
          ),
          focusedPinTheme: pinTheme,
          submittedPinTheme: pinTheme,
          errorPinTheme: pinTheme.copyDecorationWith(
            border: Border.all(color: colorScheme.error, width: 1),
          ),
          separatorBuilder:
              (index) => Gap(index != ((widget.length) - 1) ? 10 : 0),
          length: widget.length,
          textInputAction: TextInputAction.done,
          keyboardType: TextInputType.number,
          onChanged: widget.onChanged,
          onCompleted: widget.onCompleted,
          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                width: 18,
                height: 2,
                color: colorScheme.primary,
              ),
            ],
          ),
        );
      },
    );
  }
}
