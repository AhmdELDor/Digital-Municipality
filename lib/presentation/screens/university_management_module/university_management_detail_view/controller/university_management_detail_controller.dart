import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/approvals_module/approvals_course_view/model/university_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
class UniversityManagementDetailController extends GetxController{
  var searchController = TextEditingController();
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  Rx<UniversityModel> data = UniversityModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchUniversityManagementDetail();
  }

  void fetchUniversityManagementDetail() async {
    try {
      data.value = await loadJsonFromAsset<UniversityModel>(
        AppJsonPath.universityManagementDetail,
            (json) => UniversityModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorProfileDetail: $e');
      }
    }
  }
}