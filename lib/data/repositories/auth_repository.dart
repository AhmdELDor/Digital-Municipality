import '../../core/config/api_config.dart';
import '../../core/models/auth_response.dart';
import '../../core/services/api_service.dart';

class AuthRepository {
  final ApiService _apiService = ApiService();

  // Admin Login (for admin portal)
  Future<AuthResponse> loginAdmin({
    required String phonenumber,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.loginAdmin,
        data: {
          'phonenumber': phonenumber,
          'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Regular Login (for citizens/users)
  Future<AuthResponse> login({
    required String phonenumber,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.login,
        data: {
          'phonenumber': phonenumber,
          'password': password,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Register (for citizens)
  Future<AuthResponse> register({
    required String fullName,
    required String phonenumber,
    required String password,
    required String passwordConfirmation,
    required String address,
    String role = 'citizen',
  }) async {
    try {
      final response = await _apiService.post(
        ApiConfig.register,
        data: {
          'full_name': fullName,
          'phonenumber': phonenumber,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'address': address,
          'role': role,
        },
      );

      return AuthResponse.fromJson(response.data);
    } catch (e) {
      rethrow;
    }
  }

  // Logout (for regular users)
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConfig.logout);
    } catch (e) {
      // Even if API call fails, we'll clear local storage
      rethrow;
    }
  }

  // Logout Admin
  Future<void> logoutAdmin() async {
    try {
      await _apiService.post(ApiConfig.logoutAdmin);
    } catch (e) {
      rethrow;
    }
  }

  // Get Current User
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final response = await _apiService.get(ApiConfig.getUser);
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Verify phone (for forgot password flow)
  Future<Map<String, dynamic>> verifyPhone(String phonenumber) async {
    try {
      final response = await _apiService.post(
        '/api/verify-phone',
        data: {'phonenumber': phonenumber},
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phonenumber,
    required String otp,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/verify-otp',
        data: {
          'phonenumber': phonenumber,
          'otp': otp,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }

  // Reset password
  Future<Map<String, dynamic>> resetPassword({
    required String phonenumber,
    required String password,
    required String passwordConfirmation,
    required String token,
  }) async {
    try {
      final response = await _apiService.post(
        '/api/reset-password',
        data: {
          'phonenumber': phonenumber,
          'password': password,
          'password_confirmation': passwordConfirmation,
          'token': token,
        },
      );
      return response.data;
    } catch (e) {
      rethrow;
    }
  }
}
