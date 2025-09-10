import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_category_model.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/user_model.dart';
import '../model/quiz_detail_model.dart';
import '../model/status_model.dart';

class QuizMainViewController extends GetxController {
  var searchController = TextEditingController();

  Rx<QuizDetailModel> data = QuizDetailModel.empty().obs;

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
      data.value = await loadJsonFromAsset<QuizDetailModel>(
        AppJsonPath.quizData,
        (json) => QuizDetailModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorProfileDetail: $e');
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
