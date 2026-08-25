class AppConstants {
  // App Info
  static const String appName = 'البلدية الرقمية';
  static const String appNameEnglish = 'Digital Municipality';
  static const String appVersion = '1.0.0';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // User Roles
  static const String roleCitizen = 'citizen';
  static const String roleAdmin = 'admin';
  static const String roleSuperAdmin = 'superadmin';
  
  // Project Status
  static const String statusPending = 'pending';
  static const String statusInProgress = 'inprogress';
  static const String statusFinished = 'finished';
  static const String statusOnHold = 'onhold';
  
  // Request Status
  static const String requestPending = 'pending';
  static const String requestApproved = 'approved';
  static const String requestRejected = 'rejected';
  static const String requestInfoNeeded = 'info_needed';
  
  // Poll Status
  static const String pollPending = 'pending';
  static const String pollInProgress = 'in_progress';
  static const String pollEnded = 'ended';
  
  // Explore Status & Types
  static const String exploreTypePromotion = 'promotion';
  static const String exploreTypePost = 'post';
  static const String exploreStatusPending = 'pending';
  static const String exploreStatusApproved = 'approved';
  
  // OTP Status
  static const String otpPending = 'pending';
  static const String otpVerified = 'verified';
  
  // Activity Log Names
  static const String logAuthentication = 'authentication';
  static const String logPayment = 'payment';
  static const String logSecurity = 'security';
  
  // Date Formats
  static const String dateFormat = 'yyyy-MM-dd';
  static const String dateTimeFormat = 'yyyy-MM-dd HH:mm:ss';
  static const String arabicDateFormat = 'dd/MM/yyyy';
  
  // File Upload
  static const int maxImageSize = 5 * 1024 * 1024; // 5 MB
  static const List<String> allowedImageTypes = ['jpg', 'jpeg', 'png', 'gif'];
  static const List<String> allowedDocumentTypes = ['pdf', 'doc', 'docx'];
  
  // Theme
  static const String themeLight = 'light';
  static const String themeDark = 'dark';
  
  // Resolution
  static const double desktopBreakpoint = 1200;
  static const double tabletBreakpoint = 768;
  static const double mobileBreakpoint = 480;
  
  // Dashboard Resolution (80% as specified)
  static const double dashboardWidthFactor = 0.8;
}
