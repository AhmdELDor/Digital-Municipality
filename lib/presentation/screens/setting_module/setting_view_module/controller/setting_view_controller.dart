import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/language_model.dart';
import '../model/setting_model.dart';

class SettingViewController extends GetxController {
  var searchController = TextEditingController();
  RxInt selectedIndex = 0.obs;
  var isLightMode = false.obs;
  var isDarkMode = false.obs;
  List languageList = ['English', 'German', 'Spanish', 'French'];
  var questionController = TextEditingController();
  var answerController = TextEditingController();
  var privacyPolicyController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  Rx<SettingModel> setting = SettingModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    fetchSettingDetail();
  }



  final Rxn<LanguageModel> selectedLanguage = Rxn<LanguageModel>();

  void fetchSettingDetail() async {
    try {
      setting.value = await loadJsonFromAsset<SettingModel>(
        AppJsonPath.settingData,
        (json) => SettingModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error setting data: $e');
      }
    }
  }
}
