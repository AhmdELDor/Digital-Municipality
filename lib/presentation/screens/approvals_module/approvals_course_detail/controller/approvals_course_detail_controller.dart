import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
class CourseApprovalsDetailController extends GetxController{
  Rx<CourseModel> data = CourseModel.empty().obs;
  var searchController = TextEditingController();
  var feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();


  @override
  void onInit() {
    super.onInit();
    fetchApprovalCourseDetail();


  }

  void fetchApprovalCourseDetail() async {
    try {
      data.value = await loadJsonFromAsset<CourseModel>(
        AppJsonPath.courseApprovalDetail,
            (json) => CourseModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error approvalData: $e');
      }
    }
  }

}