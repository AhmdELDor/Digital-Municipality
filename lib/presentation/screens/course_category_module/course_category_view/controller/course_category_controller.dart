import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_category_model.dart';

class CourseCategoryController extends GetxController {
  var searchController = TextEditingController();
  RxList<CourseCategoryModel> courseCategoryList = <CourseCategoryModel>[].obs;
  var nameController = TextEditingController();
  var fileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes; // for web
  @override
  void onInit() {
    super.onInit();
    fetchCourseCategoryList();
  }

  void fetchCourseCategoryList() async {
    courseCategoryList.clear();
    try {
      final data = await loadListFromAsset<CourseCategoryModel>(
        AppJsonPath.courseCategoryList,
        'course_category_list',
        (json) => CourseCategoryModel.fromJson(json),
      );
      courseCategoryList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading university_management_list: $e');
      }
    }
  }

  Future<void> pickFileCommon(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf', 'jpg', 'jpeg', 'png', // docs + images
        'mp4', 'mov', 'avi', 'mkv', // videos
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
}
