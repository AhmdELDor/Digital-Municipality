class ApiConstants {
  // Base URL - Should be configured via environment variables
  static const String baseUrl = 'https://develexamunicipality.com/api/v1';
  
  // Authentication Endpoints
  static const String register = '/register';
  static const String loginMobile = '/login';
  static const String loginAdmin = '/login/admin';
  static const String logout = '/logout';
  static const String sendOtp = '/otp/send';
  static const String verifyOtp = '/otp/verify';
  
  // User Endpoints
  static const String user = '/user';
  static const String profile = '/profile';
  static const String users = '/users';
  
  // Settings Endpoints
  static const String settings = '/settings';
  
  // Projects Endpoints
  static const String projects = '/projects';
  
  // Bills Endpoints
  static const String bills = '/bills';
  static const String attachBills = '/attach-bills';
  static const String createBillForUser = '/bills/create-for-user';
  
  // Circulars Endpoints
  static const String circulars = '/circulars';
  
  // Complaints Endpoints
  static const String complaints = '/complaints';
  
  // Polls Endpoints
  static const String polls = '/polls';
  
  // Suggestions Endpoints
  static const String suggestions = '/suggestions';
  
  // Requests Endpoints
  static const String requestForms = '/request-forms';
  static const String userRequests = '/user-requests';
  
  // Notifications Endpoints
  static const String notifications = '/notifications';
  
  // Explore Endpoints
  static const String explores = '/explores';
  
  // Services Endpoints
  static const String services = '/services';
  static const String createService = '/services';
  static const String updateService = '/services'; // + /{id}
  static const String deleteService = '/services'; // + /{id}
  static const String getService = '/services'; // + /{id}
  
  // File Upload Endpoints
  static const String uploadServiceLogo = '/upload/service-logo';
  static const String deleteServiceLogo = '/upload/service-logo';
  
  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;
  
  // File Upload
  static const int maxFileSize = 5 * 1024 * 1024; // 5MB
  static const List<String> allowedImageExtensions = ['.jpg', '.jpeg', '.png', '.gif', '.webp', '.bmp'];
  
  // Real-time endpoints
  static const String websocketUrl = 'ws://127.0.0.1:8080/notifications';
  static const String sseStatsUrl = '/live-stats';
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // Timeout
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
}
