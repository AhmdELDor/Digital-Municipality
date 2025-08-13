import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/constants/app_strings.dart';
import '../../../../app/app_route.dart';
import '../../../../common_widgets/alerts/alerts.dart';

class OtpVerificationController extends GetxController {
  RxBool isLoading = false.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController otpController = TextEditingController();
  final FocusNode otpFocus = FocusNode();
  RxBool isOTPValidate = false.obs;
  Timer? timer;
  RxInt second = 60.obs;




  void startTimer() {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timer.tick == 60) {
        timer.cancel();
      }
      second.value = 60 - timer.tick;
    }).obs;
  }

  void resendCode(BuildContext context) {
    startTimer();
    showSuccessMessage(
      context: context,
      title: OtpVerificationStrings.otpSendSuccessfully,
      content: "",
    );
  }

  Future<void> submit(BuildContext context) async {
    if (otpController.text.length == 6) {
      isLoading.value = true;

      // Simulate verification delay (e.g., API call)
      await Future.delayed(Duration(seconds: 2));

      isLoading.value = false;

      context.push(AppRouteName.resetPasswordView);
    }
    else {
      showErrorMessage(
        context: context,
        title: "Please enter a valid OTP",
        content: "",
      );
    }
  }

}
