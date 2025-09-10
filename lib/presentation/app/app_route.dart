import 'package:education_admin_portal/presentation/screens/quiz_module/quiz_main_view/quiz_view_imports.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/add_course_module/add_course_view_imports.dart';
import '../screens/approvals_module/approvals_course_detail/approvals_course_detail_imports.dart';
import '../screens/approvals_module/approvals_course_view/approvals_course_view_imports.dart';
import '../screens/approvals_module/instructor_detail/instructor_detail_imports.dart';
import '../screens/approvals_module/university_detail/university_detail_imports.dart';
import '../screens/auth_module/forgot_password/forgot_password_imports.dart';
import '../screens/auth_module/otp_verification_code/otp_verification_imports.dart';
import '../screens/auth_module/reset_password/reset_password_view_imports.dart';
import '../screens/auth_module/reset_password_successfully/reset_password_successfully_imports.dart';
import '../screens/auth_module/sign_in/sign_in_imports.dart';
import '../screens/certificate_management_module/certificate_management_view/certificate_management_view_imports.dart';
import '../screens/class_management_module/add_class_view/add_class_view_imports.dart';
import '../screens/class_management_module/class_management_view/class_management_view_imports.dart';
import '../screens/class_management_module/today_class_view/today_class_view_imports.dart';
import '../screens/course_category_module/course_category_view/course_category_imports.dart';
import '../screens/course_category_module/view_course_category/view_course_category_imports.dart';
import '../screens/course_management_module/course_management_view/course_management_view_imports.dart';
import '../screens/dashboard_module/dashboard/dashboard_imports.dart';
import '../screens/dashboard_module/dashboard/model/course_model.dart';
import '../screens/dashboard_module/notes/notes_list_view_imports.dart';
import '../screens/dashboard_module/notification/notification_view_imports.dart';
import '../screens/finance_management_module/finance_management_view/finance_management_imports.dart';
import '../screens/finance_management_module/finance_management_view/widgets/add_instructor_pay_out.dart';
import '../screens/instructor_management_module/instructor_management_detail_view/instructor_management_detail_imports.dart';
import '../screens/instructor_management_module/instructor_management_view/instructor_management_view_imports.dart';
import '../screens/profile_module/profile_view/profile_view_imports.dart';
import '../screens/quiz_module/add_quiz/add_quiz_imports.dart';
import '../screens/quiz_module/leader_board/leader_board_imports.dart';
import '../screens/quiz_module/view_quiz/view_quiz_imports.dart';
import '../screens/reports_analysis_module/reports_analysis_view/reports_analysis_imports.dart';
import '../screens/setting_module/setting_view_module/setting_view_imports.dart';
import '../screens/side_drawer_module/main_dashboard/main_dashboard_imports.dart';
import '../screens/student_management_module/student_management_detail/student_management_detail_imports.dart';
import '../screens/student_management_module/student_management_view/student_management_imports.dart';
import '../screens/test_module/main_test_view/main_test_view_imports.dart';
import '../screens/university_management_module/university_management_detail_view/university_management_detail_imports.dart';
import '../screens/university_management_module/university_management_view/university_management_imports.dart';
import '../screens/user_management_module/user_management_view/user_management_view_imports.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

class AppRoute {
  static final GoRouter appRouter = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRouteName.signInView,
    routes: [
      GoRoute(
        path: AppRouteName.signInView,
        pageBuilder: (context, state) => NoTransitionPage(
          child: SignInView(), // FIXED: Correct screen
        ),
      ),
      GoRoute(
        path: AppRouteName.forgotPasswordView,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: ForgotPasswordView()),
      ),
      GoRoute(
        path: AppRouteName.otpVerificationView,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: OtpVerificationView()),
      ),
      GoRoute(
        path: AppRouteName.resetPasswordView,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: ResetPasswordView()),
      ),
      GoRoute(
        path: AppRouteName.resetPasswordSuccessfully,
        pageBuilder: (context, state) =>
            NoTransitionPage(child: ResetPasswordSuccessfully()),
      ),

      ShellRoute(
        builder: (context, state, child) {
          return MainDashboardView(child: child);
        },
        routes: [
          GoRoute(
            path: AppRouteName.dashboardView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: DashboardView()),
          ),
          GoRoute(
            path: AppRouteName.approvalsView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ApprovalsView()),
            routes: [
              GoRoute(
                path: AppRouteName.courseApprovalsDetailView,
                pageBuilder: (context, state) {
                  final extra = state.extra as Map<String, dynamic>?;
                  final course = extra?['data'] as CourseModel?;
                  final title = extra?['title'] as String?;

                  return NoTransitionPage(
                    child: CourseApprovalsDetailView(course: course, title: title),
                  );
                },
              ),

              // GoRoute(
              //   path: AppRouteName.courseApprovalsDetailView,
              //   pageBuilder: (context, state) =>
              //       NoTransitionPage(child: CourseApprovalsDetailView()),
              // ),
              GoRoute(
                path: AppRouteName.instructorDetailView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: InstructorDetailView()),
              ),
              GoRoute(
                path: AppRouteName.universityDetailView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: UniversityDetailView()),
              ),
            ],
          ),

          GoRoute(
            path: AppRouteName.notificationView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: NotificationView()),
          ),
          GoRoute(
            path: AppRouteName.notesListView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: NotesListView()),
          ),
          GoRoute(
            path: AppRouteName.courseManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: CourseManagementView()),
          ),
          GoRoute(
            path: AppRouteName.addCourseView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: AddCourseView()),
          ),
          GoRoute(
            path: AppRouteName.classManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ClassManagementView()),
            routes: [
              GoRoute(
                path: AppRouteName.todayClassView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: TodayClassView()),
              ),
              GoRoute(
                path: AppRouteName.addClassView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: AddClassView()),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteName.instructorManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: InstructorManagementView()),
            routes: [
              GoRoute(
                path: AppRouteName.instructorManagementDetailView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: InstructorManagementDetailView()),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteName.universityManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: UniversityManagementView()),
            routes: [
              GoRoute(
                path: AppRouteName.universityManagementDetailView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: UniversityManagementDetailView()),
              ),
            ],
          ),

          GoRoute(
            path: AppRouteName.courseCategoryView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: CourseCategoryView()),
            routes: [
              GoRoute(
                path: AppRouteName.viewCourseCategory,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ViewCourseCategory()),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteName.quizView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: QuizMainView()),
            routes: [
              GoRoute(
                path: AppRouteName.addQuiz,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: AddQuizView()),
              ),
              GoRoute(
                path: AppRouteName.viewQuiz,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: ViewQuiz()),
              ),
              GoRoute(
                path: AppRouteName.leaderBoardView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: LeaderBoardView()),
              ),
            ],
          ),

          GoRoute(
            path: AppRouteName.mainTestView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: MainTestView()),
            routes: [
              // GoRoute(
              //   path: AppRouteName.addQuiz,
              //   pageBuilder: (context, state) =>
              //       NoTransitionPage(child: AddQuizView()),
              // ),
            ],
          ),
          GoRoute(
            path: AppRouteName.studentManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: StudentManagementView()),
            routes: [
              GoRoute(
                path: AppRouteName.studentManagementDetailView,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: StudentManagementDetailView()),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteName.financeManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: FinanceManagementView()),
            routes: [
              GoRoute(
                path: AppRouteName.addInstructorPayOut,
                pageBuilder: (context, state) =>
                    NoTransitionPage(child: AddInstructorPayOut()),
              ),
            ],
          ),
          GoRoute(
            path: AppRouteName.reportsAnalysisView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ReportsAnalysisView()),
            routes: [
              // GoRoute(
              //   path: AppRouteName.addInstructorPayOut,
              //   pageBuilder: (context, state) =>
              //       NoTransitionPage(child: AddInstructorPayOut()),
              // ),
            ],
          ),
          GoRoute(
            path: AppRouteName.certificateManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: CertificateManagementView()),
          ),
          GoRoute(
            path: AppRouteName.userManagementView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: UserManagementView()),
          ),
          GoRoute(
            path: AppRouteName.settingView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: SettingView()),
          ),   GoRoute(
            path: AppRouteName.profileView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: ProfileView()),
          ),
        ],
      ),
    ],
  );
}

class AppRouteName {
  static const String signInView = '/sign-in';
  static const String forgotPasswordView = '/forgot-password';
  static const String otpVerificationView = '/Otp-verification-View';
  static const String resetPasswordView = '/resetPasswordView';
  static const String resetPasswordSuccessfully = '/resetPasswordSuccessfully';
  static const String dashboardView = '/dashboardView';
  static const String approvalsView = '/approvalsView';
  static const String notificationView = '/notificationView';
  static const String notesListView = '/notesListView';
  static const String courseApprovalsDetailView = 'courseApprovalsDetailView';
  static const String instructorDetailView = 'instructorDetailView';
  static const String universityDetailView = 'universityDetailView';
  static const String courseManagementView = '/courseManagementView';
  static const String addCourseView = '/addCourseView';
  static const String classManagementView = '/classManagementView';
  static const String todayClassView = 'todayClassView';
  static const String addClassView = 'addClassView';
  static const String instructorManagementView = '/instructorManagementView';
  static const String instructorManagementDetailView =
      'instructorManagementDetailView';
  static const String universityManagementView = '/universityManagementView';
  static const String universityManagementDetailView =
      'universityManagementDetailView';
  static const String courseCategoryView = '/courseCategoryView';
  static const String viewCourseCategory = 'viewCourseCategory';
  static const String quizView = '/quizView';
  static const String addQuiz = 'addQuiz';
  static const String viewQuiz = 'viewQuiz';
  static const String leaderBoardView = 'leaderBoardView';
  static const String mainTestView = '/mainTestView';
  static const String studentManagementView = '/studentManagementView';
  static const String studentManagementDetailView =
      'studentManagementDetailView';
  static const String financeManagementView = '/financeManagementView';
  static const String addInstructorPayOut = 'addInstructorPayOut';
  static const String reportsAnalysisView = '/reportsAnalysisView';
  static const String certificateManagementView = '/certificateManagementView';
  static const String userManagementView = '/userManagementView';
  static const String settingView = '/settingView';
  static const String profileView = '/profileView';
}
