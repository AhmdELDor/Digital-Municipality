import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../data/models/pagination_meta.dart';
import '../../../../../data/models/user_api_model.dart';
import '../../../../../data/repositories/user_repository.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/roles_model.dart';
import '../model/users_model.dart';

class UserManagementController extends GetxController {
  var searchController = TextEditingController();
  RxList<UsersModel> usersList = <UsersModel>[].obs;
  RxList<RolesModel> rolesList = <RolesModel>[].obs;
  
  // User form controllers
  var nameController = TextEditingController();
  var phoneController = TextEditingController();
  var addressController = TextEditingController();
  var passwordController = TextEditingController();
  var passwordConfirmationController = TextEditingController();
  
  // Phone number state
  final RxString completePhoneNumber = ''.obs;

  // Repository
  final UserRepository _userRepository = UserRepository();

  // Loading and error states
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxString errorMessage = ''.obs;

  // Pagination
  Rx<PaginationMeta?> paginationMeta = Rx<PaginationMeta?>(null);
  final RxInt currentPage = 1.obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsersFromApi();
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

  // Backend role options
  final List<String> roleList = [
    'citizen',
    'official',
    'admin',
    'superadmin',
  ];
  final RxString selectedRole = 'citizen'.obs;

  // Fetch users from API
  Future<void> fetchUsersFromApi({int page = 1}) async {
    try {
      if (page == 1) {
        isLoading.value = true;
      } else {
        isLoadingMore.value = true;
      }
      errorMessage.value = '';

      final response = await _userRepository.getUsers(page: page);
      
      if (page == 1) {
        usersList.clear();
      }
      
      final users = response.users.map((api) => UsersModel.fromApi(api)).toList();
      usersList.addAll(users);
      paginationMeta.value = response.meta;
      currentPage.value = page;
    } catch (e) {
      errorMessage.value = e.toString();
      _showError('فشل تحميل المستخدمين: ${e.toString()}');
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Load next page
  Future<void> loadNextPage() async {
    if (paginationMeta.value != null && 
        !paginationMeta.value!.isLastPage && 
        !isLoadingMore.value) {
      await fetchUsersFromApi(page: currentPage.value + 1);
    }
  }

  // Load previous page
  Future<void> loadPreviousPage() async {
    if (paginationMeta.value != null && 
        !paginationMeta.value!.isFirstPage && 
        !isLoadingMore.value) {
      await fetchUsersFromApi(page: currentPage.value - 1);
    }
  }

  // Refresh users list
  Future<void> refreshUsers() async {
    await fetchUsersFromApi(page: 1);
  }

  // Create new user
  Future<void> createUser() async {
    try {
      isLoading.value = true;
      
      final request = CreateUserRequest(
        fullName: nameController.text.trim(),
        phonenumber: completePhoneNumber.value,
        role: selectedRole.value,
        address: addressController.text.trim(),
        password: passwordController.text,
      );

      await _userRepository.createUser(request);
      
      _showSuccess('تم إنشاء المستخدم بنجاح');
      
      // Clear form
      clearForm();
      
      // Refresh list
      await refreshUsers();
    } catch (e) {
      _showError('فشل إنشاء المستخدم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Update user
  Future<void> updateUser(String userId) async {
    try {
      isLoading.value = true;
      
      final request = UpdateUserRequest(
        fullName: nameController.text.trim(),
        phonenumber: completePhoneNumber.value,
        role: selectedRole.value,
        address: addressController.text.trim(),
        password: passwordController.text.isEmpty ? null : passwordController.text,
      );

      await _userRepository.updateUser(userId, request);
      
      _showSuccess('تم تحديث المستخدم بنجاح');
      
      // Clear form
      clearForm();
      
      // Refresh list
      await refreshUsers();
    } catch (e) {
      _showError('فشل تحديث المستخدم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Delete user
  Future<void> deleteUser(String userId) async {
    try {
      isLoading.value = true;
      
      await _userRepository.deleteUser(userId);
      
      _showSuccess('تم حذف المستخدم بنجاح');
      
      // Refresh list
      await refreshUsers();
    } catch (e) {
      _showError('فشل حذف المستخدم: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Load user data for editing
  void loadUserForEdit(UsersModel user) {
    nameController.text = user.name;
    completePhoneNumber.value = user.phonenumber;
    phoneController.text = user.phonenumber; // Display in field
    addressController.text = user.address;
    selectedRole.value = user.role;
    // Password fields remain empty - only fill if changing password
  }

  // Clear form
  void clearForm() {
    nameController.clear();
    phoneController.clear();
    addressController.clear();
    passwordController.clear();
    passwordConfirmationController.clear();
    completePhoneNumber.value = '';
    selectedRole.value = 'citizen';
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

  // Helper methods for showing messages
  void _showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.success600,
      textColor: AppColors.white,
      fontSize: 16.0,
    );
  }

  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: AppColors.error500,
      textColor: AppColors.white,
      fontSize: 16.0,
    );
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
