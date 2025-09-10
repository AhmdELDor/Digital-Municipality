import 'package:get/get.dart';

class FaqModel {
  final String question;
  final String answer;
  final RxBool isSwitch;

  FaqModel({
    required this.question,
    required this.answer,
    bool isSwitch = false,
  }) : isSwitch = isSwitch.obs;

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      question: json['question'] ?? '',
      answer:json['answer'] ?? '',
      isSwitch: false
    );
  }
}