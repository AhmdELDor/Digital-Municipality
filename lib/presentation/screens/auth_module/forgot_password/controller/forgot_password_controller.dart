import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';

import '../../../../../data/repositories/auth_repository.dart';
import '../../../../app/app_route.dart';

class ForgotPasswordController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final RxBool isLoading = false.obs;
  final RxString completePhoneNumber = ''.obs;
  
  final AuthRepository _authRepository = AuthRepository();

  Future<void> submit(BuildContext context) async {
    // Validate phone number
    if (completePhoneNumber.value.isEmpty) {
      _showError('الرجاء إدخال رقم الهاتف');
      return;
    }

    Get.focusScope!.unfocus();
    isLoading.value = true;

    try {
      // Call verify phone API
      await _authRepository.verifyPhone(completePhoneNumber.value);
      
      _showSuccess('تم إرسال رمز التحقق');
      
      if (context.mounted) {
        context.push(AppRouteName.otpVerificationView);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  
  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }
  
  @override
  void onClose() {
    phoneController.dispose();
    phoneFocus.dispose();
    super.onClose();
  }
}
