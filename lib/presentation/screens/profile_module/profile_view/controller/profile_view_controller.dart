import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/profile_model.dart';

class ProfileViewController extends GetxController {
  var searchController = TextEditingController();
  Rx<ProfileModel> data = ProfileModel.empty().obs;
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController imageAController = TextEditingController();
  final TextEditingController backgroundImageAController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController joiningDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController postalCodeController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfileDetail();
  }

  void fetchUserProfileDetail() async {
    try {
      data.value = await loadJsonFromAsset<ProfileModel>(
        AppJsonPath.profileData,
        (json) => ProfileModel.fromRawJson(jsonEncode(json)),
      );

    } catch (e) {
      if (kDebugMode) {
        print('Error profileData: $e');
      }
    }
  }

  List<String> roleList = ['Super Admin', 'Admin'];
  List<String> countryList = ['India', 'Australia', 'Japan', 'Russia', 'China'];
  List<String> cityList = ['Ahmedabad', 'Surat', 'Rajkot', 'Mumbai', 'Pune'];

  final RxString selectedRole = 'Super Admin'.obs;
  final RxString selectedCountry = ''.obs;
  final RxString selectedCity = ''.obs;

  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes;

  Future<void> pickFileCommon(TextEditingController controller) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'jpg', 'jpeg', 'png', // docs + images
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
