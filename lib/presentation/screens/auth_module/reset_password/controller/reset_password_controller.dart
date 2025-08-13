import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/app_route.dart';

class ChangePasswordController extends GetxController{
  final formKey = GlobalKey<FormState>();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  FocusNode passwordFocus = FocusNode();
  FocusNode confirmPasswordFocus = FocusNode();
  RxBool isLoading = false.obs;
  Future<void> submit(BuildContext context) async {
    final isValid = formKey.currentState!.validate();
    Get.focusScope!.unfocus();

    if (!isValid) return;

    isLoading.value = true;

    await Future.delayed(Duration(seconds: 1));

    formKey.currentState!.save();

    isLoading.value = false;
    context.push(AppRouteName.resetPasswordSuccessfully);
  }

}