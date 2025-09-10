import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/course_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, kDebugMode;

class AddCourseController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var searchController = TextEditingController();

  final TextEditingController courseNameController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  final TextEditingController imageVideoController = TextEditingController();
  final TextEditingController sessionController = TextEditingController();
  final TextEditingController lectureController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  final TextEditingController outComeOneController = TextEditingController();
  final TextEditingController secondOutComeOneController = TextEditingController();
  final TextEditingController threeOutComeOneController = TextEditingController();
  final TextEditingController fourOutComeOneController = TextEditingController();
  final TextEditingController featureImageController = TextEditingController();
  final TextEditingController featureImageTwoController = TextEditingController();
  final TextEditingController requirementsController = TextEditingController();

  final TextEditingController sessionNoOneController = TextEditingController();
  final TextEditingController sessionNoOneTitleController = TextEditingController();

final TextEditingController sessionNoTwoController = TextEditingController();
  final TextEditingController sessionNoTwoTitleController = TextEditingController();

  final TextEditingController srNoController = TextEditingController();
  final TextEditingController timeOfLectureController = TextEditingController();
  final TextEditingController durationOfController = TextEditingController();

  final TextEditingController srNoSecondController = TextEditingController();
  final TextEditingController timeOfLectureSecondController = TextEditingController();
  final TextEditingController durationOfSecondController = TextEditingController();

  final List<String> categoryList = ['Designing', 'Development', 'Research'];
  final List<String> languageList = ["Hindi", "English"];
  final List<String> usersList = ['Instructor', 'Admin'];
  final List<String> assessmentTestList = ['Test 1', 'Test 2','Test 3','Test 4','Test 5'];

  final List<String> sessionList = ['Session 1', 'Session 2','Session 3','Session 4','Session 5'];
  final List<String> secondSessionList = ['Session 1', 'Session 2','Session 3','Session 4','Session 5'];

  final RxString selectedCategory = ''.obs;
  final RxString selectedCourseType = ''.obs;
  final RxString selectedLanguage = ''.obs;
  final RxString selectedUser = ''.obs;
  final RxString selectedAssessment = ''.obs;


  final RxString selectedSession = ''.obs;
  final RxString selectedSecondSession = ''.obs;


  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes;    // for web

  Future<void> pickFileCommon(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'jpg', 'jpeg', 'png', // docs + images
        'mp4', 'mov', 'avi', 'mkv' // videos
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

  void fillData(CourseModel data) {
    courseNameController.text = data.name;
    priceController.text = data.courseFees.toString();
    descriptionController.text = data.description;
    lectureController.text = 0.toString();
    sessionController.text = 'Session 1';

    outComeOneController.text = 'Outcome 1';
    secondOutComeOneController.text = 'Outcome 2';
    threeOutComeOneController.text = 'Outcome 3';
    fourOutComeOneController.text = 'Outcome 4';

    imageVideoController.text = 'ECON10233-087_Spring2025_Final1.docx.pdf';
    featureImageController.text = 'ECON10233-087_Spring2025_Final1.docx.pdf';
    featureImageTwoController.text = 'ECON10233-087_Spring2025_Final1.docx.pdf';
    requirementsController.text = data.description;

    sessionNoOneController.text ='Session 1';
    sessionNoOneTitleController.text = 'Session 2';

    sessionNoTwoController.text = 'Session 2';
    sessionNoTwoTitleController.text = 'Session 2';

    srNoController.text = 1.toString();
    timeOfLectureController.text = '10:00 AM';
    durationOfController.text = '45 min';

    srNoSecondController.text = 1.toString();
    timeOfLectureSecondController.text = '10:00 AM';
    durationOfSecondController.text = '45 min';

    // dropdowns
    selectedCategory.value = 'Designing';
    selectedCourseType.value = 'Designing';
    selectedLanguage.value = 'Hindi';
    selectedUser.value = 'Instructor';
    selectedAssessment.value = 'Test 1';
    selectedSession.value = 'Session 1';
    selectedSecondSession.value = 'Session 1';
  }

}
