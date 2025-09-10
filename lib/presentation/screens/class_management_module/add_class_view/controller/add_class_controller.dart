import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, kDebugMode;

class AddClassController extends GetxController {
  RxInt selectedIndex = 0.obs;
  var searchController = TextEditingController();

  final TextEditingController classNameController = TextEditingController();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController imageVideoController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();



  final List<String> categoryList = ['Designing', 'Development', 'Research'];

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

  Future<void> pickTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            colorScheme: ColorScheme.light(
              primary: Colors.teal, // header background color
              onPrimary: Colors.white, // header text color
              onSurface: Colors.black, // body text color
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      timeController.text = picked.format(context);
    }
  }

}
