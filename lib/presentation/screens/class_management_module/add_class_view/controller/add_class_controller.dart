import 'package:education_admin_portal/core/constants/app_colors.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb, Uint8List, kDebugMode;
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData(
            brightness: isDark ? Brightness.dark : Brightness.light,
            colorScheme: isDark
                ? ColorScheme.dark(
              primary: AppColors.primary500,   // selected highlight
              onPrimary: Colors.white,         // header text
              surface: Colors.grey.shade900,   // dialog bg
              onSurface: Colors.white,         // picker text
            )
                : ColorScheme.light(
              primary: AppColors.primary500,
              onPrimary: Colors.white,
              surface: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: AppColors.primary500, // OK / CANCEL
              ),
            ),
            timePickerTheme: TimePickerThemeData(
              backgroundColor: isDark ? Colors.grey.shade900 : Colors.white,

              // 🔥 Hour/Minute background color
              hourMinuteColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary500; // when selected
                }
                return isDark ? Colors.grey.shade800 : Colors.white; // default
              }),

              hourMinuteTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // text when selected
                }
                return AppColors.primary500; // text when not selected
              }),

              hourMinuteShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(color: AppColors.primary500, width: 1),
              ),

              // 🔥 Dial numbers
              dialTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.white; // selected number
                }
                return isDark ? Colors.white : Colors.black; // unselected numbers
              }),


              dayPeriodColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return AppColors.primary500; // selected AM/PM
                }
                return isDark ? Colors.grey.shade800 : Colors.white;
              }),
              dayPeriodTextColor: WidgetStateColor.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return Colors.white; // AM/PM text when selected
                }
                return AppColors.primary500; // AM/PM text default
              }),

              dialHandColor: AppColors.primary500,
              dialBackgroundColor: isDark ? Colors.grey.shade800 : AppColors.primary100,
              entryModeIconColor: AppColors.primary500,

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
