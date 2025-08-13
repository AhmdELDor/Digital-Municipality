import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/dashboard_model.dart';
import '../model/monthly_data_model.dart';
import '../model/user_summery_chart_model.dart';

class DashboardController extends GetxController {
  var searchController = TextEditingController();
  var noteTitleController = TextEditingController();
  var noteController = TextEditingController();
  var selectedYear = '2025'.obs;
  var selectedQuizLeaderBoardYear = '2025'.obs;
  Rx<DashboardDataModel> dashboardData = DashboardDataModel.empty().obs;
  List<MonthlyData> get chartData => yearlyData[selectedYear.value]!;
  final formKey=GlobalKey<FormState>();

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData();
  }

  static const List<String> months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  final Map<String, List<MonthlyData>> yearlyData = {
    '2023': List.generate(12, (i) => MonthlyData(months[i], (i + 1) * 90000)),
    '2024': List.generate(12, (i) => MonthlyData(months[i], (i + 1) * 70000)),
    '2025': List.generate(12, (i) => MonthlyData(months[i], (i + 1) * 20000)),
  };

List leaderBoardYear=[
  '2021',
  '2022',
  '2023',
  '2024',
  '2025',

];

  void fetchDashboardData() async {
    try {
      dashboardData.value = await loadJsonFromAsset<DashboardDataModel>(
        AppJsonPath.dashboardData,
        (json) => DashboardDataModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error loading : $e');
      }
    } finally {}
  }
  List<UserSummeryChartData> get pieChartData => [
    UserSummeryChartData('David', dashboardData.value.activeUsers.toDouble(), AppColors.success500),
    UserSummeryChartData('Steve', dashboardData.value.newUsers.toDouble(), AppColors.purple600),
    UserSummeryChartData('Jack', dashboardData.value.inactiveUsers.toDouble(), AppColors.secondary500),
  ];

}
