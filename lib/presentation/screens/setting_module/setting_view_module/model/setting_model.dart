import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/setting_module/setting_view_module/model/language_model.dart';
import 'package:education_admin_portal/presentation/screens/user_management_module/user_management_view/model/users_model.dart';
import 'faq_model.dart';

class SettingModel {
  String platFormName = '';
  List<FaqModel> faqList = [];
  List<String> privacyPolicyList = [];
  List<UsersModel> contactList = [];
  List<LanguageModel> languageList = [];

  SettingModel({
    required this.platFormName,
    required this.faqList,
    required this.privacyPolicyList,
    required this.contactList,
    required this.languageList,
  });
  SettingModel.empty();

  factory SettingModel.fromRawJson(String str) =>
      SettingModel.fromJson(json.decode(str));
  factory SettingModel.fromJson(Map<String, dynamic> json) {
    return SettingModel(
      platFormName: json['platFormName'] ?? '',
      faqList: (json['faq_list'] as List<dynamic>? ?? [])
          .map((e) => FaqModel.fromJson(e))
          .toList(),
      privacyPolicyList: (json['privacy_policy_list'] as List<dynamic>? ?? [])
          .map((e) => e.toString())
          .toList(),
      contactList: (json['contact_list'] as List<dynamic>? ?? [])
          .map((e) => UsersModel.fromJson(e))
          .toList(),
      languageList: (json['language_list'] as List<dynamic>? ?? [])
          .map((e) => LanguageModel.fromJson(e))
          .toList(),
    );
  }
}
