import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/leader_board_model.dart';

class LeaderBoardController extends GetxController {
  var searchController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  RxList<LeaderBoardModel> leaderBoardList = <LeaderBoardModel>[].obs;
  @override
  void onInit() {
    super.onInit();
    fetchLeaderBoardData();
  }

  void clearSelections() {
    dateController.clear();
    selectedRange.value=null;
  }

  void fetchLeaderBoardData() async {
    leaderBoardList.clear();
    try {
      final data = await loadListFromAsset<LeaderBoardModel>(
        AppJsonPath.leaderboardData,
        'leader_board_list',
        (json) => LeaderBoardModel.fromJson(json),
      );
      leaderBoardList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading university_management_list: $e');
      }
    }
  }

  final ranges = [
    "< 1000",
    "1000 - 1500",
    "1500 - 3000",
    "> 3000",
  ];

  // selected value
  final selectedRange = RxnString(); // null by default
}
