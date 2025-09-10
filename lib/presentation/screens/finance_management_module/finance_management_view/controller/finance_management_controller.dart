import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/finance_management_module/finance_management_view/model/payment_method_model.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../core/constants/app_json_path.dart';
import '../../../../../utils/extensions/json_helper.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/user_model.dart';
import '../../../quiz_module/quiz_main_view/model/status_model.dart';
import '../model/finance_management_module.dart';
import '../model/occurrence_model.dart';

class FinanceManagementController extends GetxController{
  var searchController = TextEditingController();
  Rx<FinanceManagementModule> data = FinanceManagementModule.empty().obs;
  var nameController = TextEditingController();
  var fileController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  var pickedFileName = ''.obs;
  var pickedFilePath = ''.obs;
  Uint8List? pickedFileBytes; // for web

  var coinsController = TextEditingController();
  var paymentIdController = TextEditingController();

  var addPaymentDateController = TextEditingController();

  final Rxn<CourseModel> selectedCourse = Rxn<CourseModel>();
  final Rxn<PaymentMethodModel> selectedPaymentMethod = Rxn<PaymentMethodModel>();
  final Rxn<StatusModel> selectedStatus = Rxn<StatusModel>();
  final Rxn<UserModel> selectedUser = Rxn<UserModel>();
  var dateController = TextEditingController();


  final Rxn<CourseModel> selectedPaymentCourse = Rxn<CourseModel>();
  final Rxn<PaymentMethodModel> selectedPaymentMethodReceived = Rxn<PaymentMethodModel>();
  final Rxn<StatusModel> selectedPaymentStatus = Rxn<StatusModel>();
  final Rxn<UserModel> selectedPaymentUser = Rxn<UserModel>();
  var datePaymentController = TextEditingController();
  final Rxn<OccurrenceModel> selectedOccurrenceValue = Rxn<OccurrenceModel>();



  final Rxn<UserModel> selectedInstructor = Rxn<UserModel>();
  final Rxn<OccurrenceModel> selectedOccurrence = Rxn<OccurrenceModel>();
  var instructorDatePaymentController = TextEditingController();
  final Rxn<PaymentMethodModel> selectedInstructorPaymentMethod = Rxn<PaymentMethodModel>();
  final Rxn<StatusModel> selectedInstructorStatus = Rxn<StatusModel>();
  var noOfPaymentController = TextEditingController();
  var paymentAmountController = TextEditingController();
  var instructorPaymentIdController = TextEditingController();


  final Rxn<OccurrenceModel> selectedSetOccurrence = Rxn<OccurrenceModel>();
  var everyMonthDateController = TextEditingController();
  var revenueController = TextEditingController();
  final Rxn<PaymentMethodModel> payOutPaymentMethod = Rxn<PaymentMethodModel>();


  @override
  void onInit() {
    super.onInit();
    fetchFinanceManagementDetail();
  }

  void fetchFinanceManagementDetail() async {
    try {
      data.value = await loadJsonFromAsset<FinanceManagementModule>(
        AppJsonPath.financeManagementData,
            (json) => FinanceManagementModule.fromRawJson(jsonEncode(json)),
      );
    } catch (e) {
      if (kDebugMode) {
        print('Error instructorProfileDetail: $e');
      }
    }
  }
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

  void clearSelections() {
    selectedCourse.value = null;
    selectedPaymentMethod.value = null;
    selectedStatus.value = null;
    selectedUser.value = null;
    dateController.clear();
  }
}