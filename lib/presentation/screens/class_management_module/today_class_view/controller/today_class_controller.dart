import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../class_management_view/model/class_model.dart';

class TodayClassController extends GetxController{
  var searchController = TextEditingController();
  DateTime currentMonth = DateTime.now();
  final CalendarController calendarController = CalendarController();
  RxList<ClassModel> todayClassicList = <ClassModel>[].obs;
  final List<String> usersList = ['Instructor', 'Admin'];
  final List<String> courseList = ['Designing', 'Cloud Computing','Cybersecurity','Data Privacy'];
  final RxString selectedUser = ''.obs;
  final RxString selectedCourse = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchTodayClassesData();
  }

  void fetchTodayClassesData() async {
    todayClassicList.clear();
    try {
      final data = await loadListFromAsset<ClassModel>(
        AppJsonPath.todayClassicData,
        'today_class_list',
            (json) => ClassModel.fromJson(json),
      );
      todayClassicList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading upcoming_class_list: $e');
      }
    }
  }

  void clearCoursesFilterSelections() {
    selectedUser.value = '';
    selectedCourse.value = '';


  }
}