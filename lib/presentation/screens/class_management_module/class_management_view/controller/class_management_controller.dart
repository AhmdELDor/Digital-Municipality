import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/class_model.dart';
class ClassManagementController extends GetxController{
  var searchController = TextEditingController();
  DateTime currentMonth = DateTime.now();
  final CalendarController calendarController = CalendarController();
  RxList<ClassModel> upComingClassicList = <ClassModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchUpComingClassesData();
  }

  void fetchUpComingClassesData() async {
    upComingClassicList.clear();
    try {
      final data = await loadListFromAsset<ClassModel>(
        AppJsonPath.upcomingClassicData,
        'upcoming_class_list',
            (json) => ClassModel.fromJson(json),
      );
      upComingClassicList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading upcoming_class_list: $e');
      }
    }
  }

}