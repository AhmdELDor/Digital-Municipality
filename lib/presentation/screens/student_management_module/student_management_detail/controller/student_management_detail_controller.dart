import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/student_management_detail_model.dart';

class StudentManagementDetailController extends GetxController {
  var searchController = TextEditingController();
  Rx<StudentManagementDetailModel> data =
      StudentManagementDetailModel.empty().obs;
  var feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    fetchInstructorDetail();
  }

  void fetchInstructorDetail() async {
    try {
      data.value = await loadJsonFromAsset<StudentManagementDetailModel>(
        AppJsonPath.studentManagementDetail,
        (json) => StudentManagementDetailModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error studentManagementDetail: $e');
      }
    }
  }
}
