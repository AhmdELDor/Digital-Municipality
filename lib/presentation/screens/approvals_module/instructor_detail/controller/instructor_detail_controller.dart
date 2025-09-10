import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';

class InstructorDetailController extends GetxController{
  var searchController = TextEditingController();
  Rx<InstructorModel> data = InstructorModel.empty().obs;
  var feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    fetchInstructorDetail();
  }

  void fetchInstructorDetail() async {
    try {
      data.value = await loadJsonFromAsset<InstructorModel>(
        AppJsonPath.instructorDetail,
            (json) => InstructorModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorDetail: $e');
      }
    }
  }
}