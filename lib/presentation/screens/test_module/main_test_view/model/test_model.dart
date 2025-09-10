import 'dart:convert';
import 'package:get/get.dart';

class TestModel {
  int id=0;
  String name='';
  String image='';
  String tag='';
  String course='';
  int totalQuestions=0;
  double totalAttendees=0.0;
  String answerChangeable='';
  RxBool isSwitch = false.obs;
  String question = '';
  int correctOptionIndex = 0;
  List<TestOption> options = [];
  int selectedOptionIndex = -1;
  List<TestModel> quizList = [];
  TestModel.empty();
  TestModel({
    required this.id,
    required this.name,
    required this.image,
    required this.tag,
    required this.course,
    required this.totalQuestions,
    required this.totalAttendees,
    required this.answerChangeable,
    required this.isSwitch,
    required this.question,
    required this.correctOptionIndex,
    required this.options,
    required this.selectedOptionIndex,
    required this.quizList,
  });
  factory TestModel.fromRawJson(String str) =>
      TestModel.fromJson(json.decode(str));

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
    id: json['id'] ?? 0,
    name: json['name'] ?? '',
    image: json['image'] ?? '',
    tag: json['tag'] ?? '',
    course: json['course'] ?? '',
    totalQuestions: json['totalQuestions'] ?? 0,
    totalAttendees: json['totalAttendees'] ?? 0.0,
    answerChangeable: json['answerChangeable'] ?? '',
    isSwitch: false.obs,
    question: json['question'] ?? '',
    correctOptionIndex: json['correctOptionIndex'] ?? 0,
    options:
    (json['options'] as List<dynamic>?)
        ?.map((e) => TestOption.fromJson(e))
        .toList() ??
        [],
    selectedOptionIndex: json['selectedOptionIndex'] ?? -1,
    quizList:
    (json['quiz_list'] as List<dynamic>?)
        ?.map((e) => TestModel.fromJson(e))
        .toList() ??
        [],
  );
}

class TestOption {
  String value = '';
  final bool isImage;
  String key = '';
  TestOption({required this.value, required this.isImage, required this.key});

  factory TestOption.fromJson(Map<String, dynamic> json) {
    return TestOption(
      value: json['value'] ?? '',
      isImage: json['isImage'] ?? false,
      key: json['key'] ?? '',
    );
  }
}
