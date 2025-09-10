import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../model/approvals_model.dart';

class ApprovalsViewController extends GetxController {
  var searchController = TextEditingController();
  var dateController = TextEditingController();
  var instructorDateController = TextEditingController();
  var universityDateController = TextEditingController();
  Rx<ApprovalsModel> data = ApprovalsModel.empty().obs;

  RxInt selectedIndex = 0.obs;
  final RxString selectedCourseCategory = ''.obs;
  final RxString selectedLanguage = ''.obs;
  final RxDouble selectedPrice = 0.0.obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final List<String> usersList = ['Instructor', 'Admin'];
  final RxString selectedUser = ''.obs;
  final RxString selectedInstructorUser = ''.obs;

  final RxString identityProofType = ''.obs;
  final RxString qualificationProofType = ''.obs;
  final RxString registrationProofType = ''.obs;


  var feedbackController = TextEditingController();
  var instructorFeedbackController = TextEditingController();
  var universityFeedbackController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchApprovalDetail();
  }

  void fetchApprovalDetail() async {
    try {
      data.value = await loadJsonFromAsset<ApprovalsModel>(
        AppJsonPath.approvalData,
        (json) => ApprovalsModel.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error approvalData: $e');
      }
    }
  }

  void selectDate(DateTime pickedDate) {
    final formattedDate = DateFormat('dd MMMM yyyy').format(pickedDate);
    dateController.text = formattedDate;
  }

  void clearCoursesFilterSelections() {
    selectedUser.value = '';
    selectedCourseCategory.value = '';
    selectedLanguage.value = '';
    selectedPrice.value = 0.0;
    dateController.clear();

  }

  void clearInstructorFilterSelections() {
    selectedInstructorUser.value = '';
    identityProofType.value = '';
    qualificationProofType.value = '';
    registrationProofType.value = '';
    instructorDateController.clear();
  }

  void clearUniversityFilterSelections() {
    registrationProofType.value = '';
    universityDateController.clear();
  }

  void clearAllSelection() {
    selectedIndex.value == 0
        ? clearCoursesFilterSelections()
        : selectedIndex.value == 1
        ? clearInstructorFilterSelections()
        : clearUniversityFilterSelections();
  }
}
