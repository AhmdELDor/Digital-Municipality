
import 'package:education_admin_portal/presentation/screens/approvals_module/approvals_course_view/model/university_model.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
class UniversityManagementViewController extends GetxController{
  var searchController = TextEditingController();
RxList<UniversityModel> universityList=<UniversityModel>[].obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  @override
  void onInit() {
    super.onInit();
    fetchUniversityData();
  }



  void fetchUniversityData() async {
    universityList.clear();
    try {
      final data = await loadListFromAsset<UniversityModel>(
        AppJsonPath.universityManagementList,
        'university_management_list',
            (json) => UniversityModel.fromJson(json),
      );
      universityList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading university_management_list: $e');
      }
    }
  }
}