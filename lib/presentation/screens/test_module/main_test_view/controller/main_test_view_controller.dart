import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_category_model.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/user_model.dart';
import '../../../quiz_module/quiz_main_view/model/status_model.dart';
import '../model/test_detail_model.dart';

class MainTestViewController extends GetxController {
  var searchController = TextEditingController();

  Rx<TestDetailModel> data = TestDetailModel.empty().obs;

  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  final Rxn<CourseModel> selectedCourse = Rxn<CourseModel>();
  final Rxn<CourseCategoryModel> selectedCategory = Rxn<CourseCategoryModel>();
  final Rxn<StatusModel> selectedStatus = Rxn<StatusModel>();
  final Rxn<UserModel> createdBy = Rxn<UserModel>();

  @override
  void onInit() {
    super.onInit();
    fetchQuizData();
  }

  void fetchQuizData() async {
    try {
      data.value = await loadJsonFromAsset<TestDetailModel>(
        AppJsonPath.testData,
        (json) => TestDetailModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error test_list: $e');
      }
    }
  }

  void clearSelections() {
    selectedCourse.value = null;
    selectedCategory.value = null;
    selectedStatus.value = null;
    createdBy.value = null;
  }
}
