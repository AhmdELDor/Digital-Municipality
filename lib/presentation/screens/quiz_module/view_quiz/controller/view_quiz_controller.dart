import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../quiz_main_view/model/quiz_model.dart';
class ViewQuizController extends GetxController{
  var searchController = TextEditingController();
  Rx<QuizModel> data = QuizModel.empty().obs;
  @override
  void onInit() {
    super.onInit();
    fetchQuizData();
  }

  void fetchQuizData() async {
    try {
      data.value = await loadJsonFromAsset<QuizModel>(
        AppJsonPath.viewQuizData,
            (json) => QuizModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorProfileDetail: $e');
      }
    }
  }

}