import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/instructor_model.dart';


class InstructorManagementController extends GetxController{
  var searchController = TextEditingController();
  RxList<InstructorModel> instructorManagementList = <InstructorModel>[].obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchInstructorManagementData();
  }


  void fetchInstructorManagementData() async {
    instructorManagementList.clear();
    try {
      final data = await loadListFromAsset<InstructorModel>(
        AppJsonPath.instructorManagementData,
        'instructor_management_list',
            (json) => InstructorModel.fromJson(json),
      );
      instructorManagementList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notificationList: $e');
      }
    }
  }
}