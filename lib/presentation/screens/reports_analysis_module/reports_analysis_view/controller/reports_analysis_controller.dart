import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/reports_analysis_model.dart';


class ReportsAnalysisController extends GetxController{
  Rx<ReportsAnalysisModel> data = ReportsAnalysisModel.empty().obs;
  var searchController = TextEditingController();
  @override
  void onInit() {
    super.onInit();
    fetchReportsAnalysisDetail();
  }

  void fetchReportsAnalysisDetail() async {
    try {
      data.value = await loadJsonFromAsset<ReportsAnalysisModel>(
        AppJsonPath.reportsAnalysisData,
            (json) => ReportsAnalysisModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error reportsAnalysisData: $e');
      }
    }
  }

}