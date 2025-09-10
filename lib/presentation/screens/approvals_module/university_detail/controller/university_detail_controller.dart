import 'dart:convert';

import 'package:education_admin_portal/presentation/screens/approvals_module/approvals_course_view/model/university_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';

class UniversityDetailController extends GetxController{
  var searchController = TextEditingController();
  Rx<UniversityModel> data = UniversityModel.empty().obs;
  var feedbackController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    fetchUniversityDetail();
  }

  void fetchUniversityDetail() async {
    try {
      data.value = await loadJsonFromAsset<UniversityModel>(
        AppJsonPath.universityDetail,
            (json) => UniversityModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorDetail: $e');
      }
    }
  }
}