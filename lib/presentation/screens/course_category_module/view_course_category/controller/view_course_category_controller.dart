import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';


class ViewCourseCategoryController extends GetxController{
  RxList<CourseModel> courseManagementList = <CourseModel>[].obs;
  final List<String> usersList = ['Instructor', 'Admin'];
  final List<String> statusList = ['In-Progress', 'Completed','Pending'];
  final List<String> createdByList = ['Instructor', 'Admin'];
  final RxString selectedUser = ''.obs;
  final RxString selectedStatus = ''.obs;
  final RxString createdBy = ''.obs;
  var dateController = TextEditingController();
  var searchController = TextEditingController();


  @override
  void onInit() {
    super.onInit();
    fetchNotificationData();
  }

  void fetchNotificationData() async {
    courseManagementList.clear();
    try {
      final data = await loadListFromAsset<CourseModel>(
        AppJsonPath.courseManagement,
        'course_management_list',
            (json) => CourseModel.fromJson(json),
      );
      courseManagementList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading notificationList: $e');
      }
    }
  }
  void clearSelections() {
    selectedUser.value = '';
    selectedStatus.value = '';
    createdBy.value = '';
    dateController.clear();

  }
}