import 'dart:convert';
import 'package:education_admin_portal/presentation/screens/dashboard_module/dashboard/model/instructor_model.dart';
import '../../../dashboard_module/dashboard/model/course_model.dart';
import '../../../dashboard_module/dashboard/model/user_model.dart';
import '../../../quiz_module/quiz_main_view/model/status_model.dart';
import '../../../student_management_module/student_management_detail/model/payment_history_model.dart';
import 'occurrence_model.dart';
import 'payment_method_model.dart';

class FinanceManagementModule {
  int totalEarning = 0;
  int courseSelling = 0;
  int courseEarning = 0;
  int instructorPayOut = 0;
  List<PaymentMethodModel> paymentMethodsList = [];
  List<PaymentHistoryModel> paymentReceivedList = [];
  List<InstructorModel> instructorPayOutList = [];
  List<CourseModel> coursesList = [];
  List<StatusModel> statusList = [];
  List<UserModel> usersList = [];
  List<UserModel> instructorList = [];
  List<OccurrenceModel> occurrenceList = [];

  FinanceManagementModule({
    required this.totalEarning,
    required this.courseSelling,
    required this.courseEarning,
    required this.instructorPayOut,
    required this.paymentMethodsList,
    required this.paymentReceivedList,
    required this.instructorPayOutList,
    required this.coursesList,
    required this.statusList,
    required this.usersList,
    required this.instructorList,
    required this.occurrenceList,
  });
  FinanceManagementModule.empty();

  factory FinanceManagementModule.fromRawJson(String str) =>
      FinanceManagementModule.fromJson(json.decode(str));
  factory FinanceManagementModule.fromJson(Map<String, dynamic> json) {
    return FinanceManagementModule(
      totalEarning: json['total_earning'] ?? 0,
      courseSelling: json['course_selling'] ?? 0,
      courseEarning: json['course_earning'] ?? 0,
      instructorPayOut: json['instructor_pay_out'] ?? 0,
      paymentMethodsList: (json['payment_methods_list'] as List<dynamic>? ?? [])
          .map((e) => PaymentMethodModel.fromJson(e))
          .toList(),
      paymentReceivedList:
          (json['payment_received_list'] as List<dynamic>? ?? [])
              .map((e) => PaymentHistoryModel.fromJson(e))
              .toList(),
      instructorPayOutList:
          (json['instructor_pay_out_list'] as List<dynamic>? ?? [])
              .map((e) => InstructorModel.fromJson(e))
              .toList(),
      coursesList:
          (json['courses_list'] as List<dynamic>?)
              ?.map((e) => CourseModel.fromJson(e))
              .toList() ??
          [],
      statusList:
          (json['status_list'] as List<dynamic>?)
              ?.map((e) => StatusModel.fromJson(e))
              .toList() ??
          [],
      usersList:
          (json['users_list'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e))
              .toList() ??
          [],
      instructorList:
          (json['instructor_list'] as List<dynamic>?)
              ?.map((e) => UserModel.fromJson(e))
              .toList() ??
          [],
      occurrenceList:
          (json['occurrence_list'] as List<dynamic>?)
              ?.map((e) => OccurrenceModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
