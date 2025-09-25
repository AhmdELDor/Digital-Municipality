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
  final Map<String, List<String>> countryCityMap = {
    'India': ['Ahmedabad', 'Surat', 'Rajkot', 'Mumbai', 'Pune'],
    'Australia': ['Sydney', 'Melbourne', 'Perth'],
    'Japan': ['Tokyo', 'Osaka', 'Kyoto'],
    'Russia': ['Moscow', 'Saint Petersburg'],
    'China': ['Beijing', 'Shanghai', 'Guangzhou'],
  };

  List<String> roleList = ['Super Admin', 'Admin'];


  final RxString selectedRole = 'Super Admin'.obs;


  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes;
  RxList<String> countryList = <String>['India', 'Australia', 'Japan', 'Russia', 'China'].obs;
  RxList<String> cityList = <String>[].obs;

  RxString? selectedCountry = RxString('');
  RxString? selectedCity = RxString('');

  void updateCities(String country) {
    cityList.value = countryCityMap[country] ?? [];
    selectedCity?.value = ''; // reset when country changes
  }
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
