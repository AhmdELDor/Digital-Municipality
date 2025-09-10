import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/instructor_management_detail.dart';
class InstructorManagementDetailController extends GetxController{
  var searchController = TextEditingController();
  Rx<InstructorManagementDetail> data = InstructorManagementDetail.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchInstructorProfileDetail();
  }

  void fetchInstructorProfileDetail() async {
    try {
      data.value = await loadJsonFromAsset<InstructorManagementDetail>(
        AppJsonPath.instructorProfileDetail,
            (json) => InstructorManagementDetail.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorProfileDetail: $e');
      }
    }
  }

}