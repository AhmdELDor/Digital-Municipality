import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, kDebugMode;

import '../../../test_module/main_test_view/model/test_model.dart';
import '../../quiz_main_view/model/quiz_model.dart';


class AddQuizController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var searchController = TextEditingController();

  final TextEditingController quizNameController = TextEditingController();
  final TextEditingController imageVideoController = TextEditingController();
  final TextEditingController questionsController = TextEditingController();
  final TextEditingController enterQuestionsController =
      TextEditingController();

  final TextEditingController imageAController = TextEditingController();
  final TextEditingController imageBController = TextEditingController();
  final TextEditingController singleQuestionOneController =
      TextEditingController();
  final TextEditingController singleQuestionTwoController =
      TextEditingController();

  final List<String> categoryList = ['Designing', 'Development', 'Research'];
  final List<String> languageList = ["Hindi", "English"];
  final List<String> coursesList = [
    'Quiz for Designers',
    'Quiz for Developers',
    'Quiz for Marketers',
  ];

  final RxString selectedCategory = ''.obs;
  // final RxString selectedCourseType = ''.obs;
  final RxString selectedLanguage = ''.obs;
  final RxString selectedCourses = ''.obs;

  final List<String> selectedTypeList = [
    'Multiple Choice Question',
    'A/B Answer',

  ];

  var selectedType = 'Multiple Choice Question'.obs;
  var selectedRadioIndex = (-1).obs;

  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes; // for web

  Future<void> pickFileCommon(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg',
        'jpeg',
        'png', // docs + images
      ],
    );

    if (result != null) {
      final file = result.files.single;

      pickedFileName.value = file.name;

      if (kIsWeb) {
        pickedFileBytes = file.bytes; // On web use bytes
        pickedFilePath.value = ''; // path not available
      } else {
        pickedFilePath.value = file.path ?? '';
        pickedFileBytes = null;
      }

      // Show name in text field
      controller.text = pickedFileName.value;

      if (kDebugMode) {
        print("Picked file: ${pickedFileName.value}");
      }
    }
  }

  void selectionOfRadio(int index) {
    selectedRadioIndex.value = index;
  }

  // Options List for Multiple Choice
  var options = <TextEditingController>[
    TextEditingController(), // Option 1 (A)
    TextEditingController(), // Option 2 (B)
    TextEditingController(), // Option 3 (C)
    TextEditingController(), // Option 4 (D)
  ].obs;

  void swapOptions(int i, int j) {
    final temp = options[i];
    options[i] = options[j];
    options[j] = temp;
    options.refresh();
  }

  // 🔹 Manage Question Number
  RxInt questionIndex = 1.obs;



  // 🔹 Save & Next
  void saveAndNext() {
    // You can save current question to a list or API here

    // Next question number
    questionIndex.value++;

    // Reset fields for next question
    resetFields();
  }

  // 🔹 Reset all fields
  void resetFields() {
    enterQuestionsController.clear();
    for (var c in options) {
      c.clear();
    }
    singleQuestionOneController.clear();
    singleQuestionTwoController.clear();
    imageAController.clear();
    imageBController.clear();
    selectedRadioIndex.value = -1;
  }



  void fillData(dynamic data) {

    if (data is QuizModel) {
      quizNameController.text = data.name;
      questionsController.text = data.totalQuestions.toString();
      enterQuestionsController.text = data.question;

      for (int i = 0; i < options.length; i++) {
        if (i < data.options.length) {
          options[i].text = data.options[i].value;
        } else {
          options[i].clear();
        }
      }

      selectedRadioIndex.value = data.correctOptionIndex;
    }
    else if (data is TestModel) {
      quizNameController.text = data.name;
      questionsController.text = data.totalQuestions.toString();
      enterQuestionsController.text = data.question;

      // … map its fields into your controllers
    }

    // common defaults
    selectedCategory.value = 'Designing';
    selectedLanguage.value = 'Hindi';
    selectedCourses.value = 'Quiz for Designers';
    //selectedType.value = 'multiple';
    questionIndex.value = 1;


  }

}
