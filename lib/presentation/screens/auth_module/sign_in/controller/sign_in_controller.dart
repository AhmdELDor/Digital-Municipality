import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/services/auth_storage_service.dart';
import '../../../../../data/repositories/auth_repository.dart';
import '../../../../app/app_route.dart';

class SignInController extends GetxController {
  final formKey = GlobalKey<FormState>();
  final TextEditingController phoneController = TextEditingController();
  final FocusNode phoneFocus = FocusNode();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode passwordFocus = FocusNode();

  final RxBool isLoading = false.obs;
  final RxBool isRememberMe = false.obs;
  final RxString completePhoneNumber = ''.obs;

  final AuthRepository _authRepository = AuthRepository();
  final AuthStorageService _authStorage = AuthStorageService();

  @override
  void onInit() {
    super.onInit();
    // Ensure loading state is reset
    isLoading.value = false;
    
    // Load saved preferences
    isRememberMe.value = _authStorage.getRememberMe();
    if (isRememberMe.value) {
      final savedPhone = _authStorage.getSavedPhone();
      if (savedPhone != null) {
        phoneController.text = savedPhone;
      }
    }
  }

  Future<void> submit(BuildContext context) async {
    // Prevent double submission
    if (isLoading.value) {
      return;
    }

    // Validate phone number
    if (completePhoneNumber.value.isEmpty) {
      _showError('الرجاء إدخال رقم الهاتف');
      return;
    }

    // Validate password
    if (passwordController.text.isEmpty) {
      _showError('الرجاء إدخال كلمة المرور');
      return;
    }

    if (passwordController.text.length < 6) {
      _showError('كلمة المرور يجب أن تكون على الأقل 6 أحرف');
      return;
    }

    Get.focusScope!.unfocus();

    isLoading.value = true;

    try {
      // Call admin login API (since this is admin portal)
      final response = await _authRepository.loginAdmin(
        phonenumber: completePhoneNumber.value,
        password: passwordController.text,
      );

      if (response.success && response.data != null) {
        // Save token and user data
        await _authStorage.saveToken(response.data!.token);
        await _authStorage.saveUser(response.data!.user);

        // Save remember me preference
        await _authStorage.saveRememberMe(isRememberMe.value);
        if (isRememberMe.value) {
          await _authStorage.saveSavedPhone(completePhoneNumber.value);
        }

        // Show success message
        _showSuccess('تم تسجيل الدخول بنجاح');

        // Navigate to dashboard
        if (context.mounted) {
          context.go(AppRouteName.dashboardView);
        }
      } else {
        _showError(response.message);
      }
    } catch (e) {
      _showError(e.toString());
    } finally {
      // ALWAYS reset loading state, whether success, error, or navigation
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
    // Reset loading state when controller is disposed
    isLoading.value = false;
    phoneController.dispose();
    phoneFocus.dispose();
    passwordController.dispose();
    passwordFocus.dispose();
    super.onClose();
  }
}
