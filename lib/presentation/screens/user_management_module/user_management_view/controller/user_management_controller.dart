import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/roles_model.dart';
import '../model/users_model.dart';

class UserManagementController extends GetxController {
  var searchController = TextEditingController();
  RxList<UsersModel> usersList = <UsersModel>[].obs;
  RxList<RolesModel> rolesList = <RolesModel>[].obs;
  var nameController = TextEditingController();
  var emailController = TextEditingController();
  var imageController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchUsersData();
    fetchRolesData();
    for (var p in permissions) {
      permissionMatrix[p] = {
        "create": false,
        "read": false,
        "update": false,
        "delete": false,
      };
    }
  }

  final List<String> roleList = [
    'Admin',
    'Instructor',

  ];
  final RxString selectedRole = ''.obs;

  void fetchUsersData() async {
    usersList.clear();
    try {
      final data = await loadListFromAsset<UsersModel>(
        AppJsonPath.userManagementData,
        'users_list',
        (json) => UsersModel.fromJson(json),
      );
      usersList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading users_list: $e');
      }
    }
  }

  void fetchRolesData() async {
    rolesList.clear();
    try {
      final data = await loadListFromAsset<RolesModel>(
        AppJsonPath.userManagementData,
        'roles_list',
        (json) => RolesModel.fromJson(json),
      );
      rolesList.addAll(data);
    } catch (e) {
      if (kDebugMode) {
        print('Error loading roles_list: $e');
      }
    }
  }

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

  final TextEditingController roleController = TextEditingController();

  final List<String> permissions = [
    "Course",
    "Class",
    "Quiz",
    "Student",
    "University",
    "Test",
    "Payment",
  ];

  /// permissions[permission][action] = bool
  final RxMap<String, Map<String, bool>> permissionMatrix = <String, Map<String, bool>>{}.obs;



  void togglePermission(String permission, String action, bool value) {
    final updated = Map<String, bool>.from(permissionMatrix[permission]!);
    updated[action] = value;
    permissionMatrix[permission] = updated; // notify UI
  }

  void saveRole(BuildContext context) {
    final roleName = roleController.text.trim();
    // if (roleName.isEmpty) {
    //   showErrorMessage(context: context,content: '',title: "Error Please enter a role name", );
    //   return;
    // }
    debugPrint("✅ Role: $roleName");
    debugPrint("✅ Permissions: $permissionMatrix");
    Navigator.pop(context);
  }
}
