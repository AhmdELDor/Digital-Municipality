/// API Configuration
/// 
/// Update these values based on your environment
class ApiConfig {
  // Base URLs for different environments
  static const String _devBaseUrl = 'http://localhost:8080';
  static const String _stagingBaseUrl = 'https://staging.your-api.com';
  static const String _productionBaseUrl = 'https://api.your-api.com';

  // Current environment - change this based on your needs
  static const Environment currentEnvironment = Environment.development;

  // Get base URL based on current environment
  static String get baseUrl {
    switch (currentEnvironment) {
      case Environment.development:
        return _devBaseUrl;
      case Environment.staging:
        return _stagingBaseUrl;
      case Environment.production:
        return _productionBaseUrl;
    }
  }

  // API Endpoints
  static const String loginAdmin = '/api/login/admin';
  static const String login = '/api/login';
  static const String register = '/api/register';
  static const String logout = '/api/logout';
  static const String logoutAdmin = '/api/logout/admin';
  static const String getUser = '/api/user';
  static const String verifyPhone = '/api/verify-phone';
  static const String verifyOtp = '/api/verify-otp';
  static const String resetPassword = '/api/reset-password';

  // User management endpoints
  static const String users = '/api/users';
  static String userById(String id) => '/api/users/$id';

  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Headers
  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/json',
    'Content-Type': 'application/json',
  };
}

enum Environment {
  development,
  staging,
  production,
}
