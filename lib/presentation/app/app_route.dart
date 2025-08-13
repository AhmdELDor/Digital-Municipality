import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/approvals_module/approvals_course_detail/approvals_course_detail_imports.dart';
import '../screens/approvals_module/approvals_module/approvals_view_imports.dart';
import '../screens/auth_module/forgot_password/forgot_password_imports.dart';
import '../screens/auth_module/otp_verification_code/otp_verification_imports.dart';
import '../screens/auth_module/reset_password/reset_password_view_imports.dart';
import '../screens/auth_module/reset_password_successfully/reset_password_successfully_imports.dart';
import '../screens/auth_module/sign_in/sign_in_imports.dart';
import '../screens/dashboard_module/dashboard/dashboard_imports.dart';
import '../screens/dashboard_module/notes/notes_list_view_imports.dart';
import '../screens/dashboard_module/notification/notification_view_imports.dart';
import '../screens/side_drawer_module/main_dashboard/main_dashboard_imports.dart';

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
          ),GoRoute(
            path: AppRouteName.courseApprovalsDetailView,
            pageBuilder: (context, state) =>
                NoTransitionPage(child: CourseApprovalsDetailView()),
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
  static const String courseApprovalsDetailView = '/courseApprovalsDetailView';
}
