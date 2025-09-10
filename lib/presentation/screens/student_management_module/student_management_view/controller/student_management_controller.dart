import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/student_management_model.dart';

class StudentManagementController extends GetxController{
  var searchController = TextEditingController();
  RxList<StudentManagementModel> studentManagementList=<StudentManagementModel>[].obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    fetchStudentManagementData();
  }



  void fetchStudentManagementData() async {
    studentManagementList.clear();
    try {
      final data = await loadListFromAsset<StudentManagementModel>(
        AppJsonPath.studentManagementData,
        'student_management_list',
            (json) => StudentManagementModel.fromJson(json),
      );
      studentManagementList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading university_management_list: $e');
      }
    }
  }
}