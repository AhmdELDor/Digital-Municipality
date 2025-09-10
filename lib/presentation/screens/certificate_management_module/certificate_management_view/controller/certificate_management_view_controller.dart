import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CertificateManagementViewController extends GetxController {
  var searchController = TextEditingController();
  var logoController = TextEditingController();
  var backgroundController = TextEditingController();
  var studentNamedController = TextEditingController();
  var customTextController = TextEditingController();
  var signatureController = TextEditingController();

  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes;

  final List<String> courseList = [
    'Logo Design in Adobe Illustrator 10 graphic tools',
    'Advanced Web Animation with CSS 5 design techniques',

  ];
  final RxString selectedCourse = ''.obs;

  var dateController = TextEditingController();

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
