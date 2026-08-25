import 'package:flutter/foundation.dart';
import '../constants/api_constants.dart';
import 'api_service.dart';
import 'storage_service.dart';

class AuthService {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthService(this._apiService, this._storageService);

  // Admin Login (Phone + Password)
  Future<Map<String, dynamic>> loginAdmin({
    required String phonenumber,
    required String password,
  }) async {
    try {
      // Print request details
      debugPrint('========== LOGIN REQUEST ==========');
      debugPrint('URL: ${ApiConstants.loginAdmin}');
      debugPrint('Phone: $phonenumber');
      debugPrint('Password: ${"*" * password.length}'); // Hide actual password
      debugPrint('===================================');
      
      final response = await _apiService.post(
        ApiConstants.loginAdmin,
        data: {
          'phonenumber': phonenumber,
          'password': password,
        },
      );

      // Print response details
      debugPrint('========== LOGIN RESPONSE ==========');
      debugPrint('Status Code: ${response.statusCode}');
      debugPrint('Response Data: ${response.data}');
      debugPrint('====================================');

      debugPrint('[AuthService] login status=${response.statusCode}');
      try {
        debugPrint('[AuthService] login body=${response.data}');
        final token = (response.data is Map<String, dynamic>)
            ? (response.data['data']?['token'])
            : null;
        if (token != null) {
          debugPrint('[AuthService] login token=$token');
        }
      } catch (_) {
        debugPrint('[AuthService] login body=<unparsed ${response.data}>');
      }

      if (response.statusCode == 200 && response.data['code'] == 200) {
        final data = response.data['data'];
        final token = data['token'];
        final user = data['user'];

        // Save authentication data
        await _storageService.saveAuthToken(token);
        await _storageService.saveUserId(user['id']);
        await _storageService.saveUserRole(user['role']);
        await _storageService.saveUserPhone(user['phonenumber']);
        await _storageService.saveUserName(user['full_name']);
        await _storageService.setLoggedIn(true);

        return {
          'success': true,
          'user': user,
          'token': token,
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'فشل تسجيل الدخول',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Send OTP
  Future<Map<String, dynamic>> sendOtp({
    required String phonenumber,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.sendOtp,
        data: {
          'phonenumber': phonenumber,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'تم إرسال رمز التحقق',
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'فشل إرسال رمز التحقق',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Verify OTP
  Future<Map<String, dynamic>> verifyOtp({
    required String phonenumber,
    required String token,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.verifyOtp,
        data: {
          'phonenumber': phonenumber,
          'token': token,
        },
      );

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'تم التحقق بنجاح',
          'data': response.data['data'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'رمز التحقق غير صحيح',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Register (for citizen - not used in admin dashboard)
  Future<Map<String, dynamic>> register({
    required String fullName,
    required String phonenumber,
    required String address,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'full_name': fullName,
          'phonenumber': phonenumber,
          'address': address,
          'password': password,
        },
      );

      if (response.statusCode == 201 && response.data['code'] == 201) {
        final data = response.data['data'];
        return {
          'success': true,
          'user': data['user'],
          'token': data['token'],
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'فشل التسجيل',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Logout
  Future<Map<String, dynamic>> logout() async {
    try {
      final response = await _apiService.post(ApiConstants.logout);

      // Clear local storage regardless of API response
      await _storageService.clearSession();

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': response.data['message'] ?? 'تم تسجيل الخروج بنجاح',
        };
      } else {
        return {
          'success': true, // Still success because we cleared local storage
          'message': 'تم تسجيل الخروج محلياً',
        };
      }
    } catch (e) {
      // Clear local storage even if API call fails
      await _storageService.clearSession();
      return {
        'success': true,
        'message': 'تم تسجيل الخروج محلياً',
      };
    }
  }

  // Get current user profile
  Future<Map<String, dynamic>> getProfile() async {
    try {
      final response = await _apiService.get(ApiConstants.profile);

      if (response.statusCode == 200) {
        return {
          'success': true,
          'user': response.data['data'],
          'message': response.data['message'],
        };
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'فشل جلب البيانات',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': e.toString(),
      };
    }
  }

  // Check if user is logged in
  bool isLoggedIn() {
    return _storageService.isLoggedIn() && 
           _storageService.getAuthToken() != null;
  }

  // Get user role
  String? getUserRole() {
    return _storageService.getUserRole();
  }

  // Check if user is admin
  bool isAdmin() {
    final role = getUserRole();
    return role == 'admin' || role == 'superadmin';
  }

  // Check if user is super admin
  bool isSuperAdmin() {
    return getUserRole() == 'superadmin';
  }

  // Get auth token
  String? getAuthToken() {
    return _storageService.getAuthToken();
  }

  // Get user ID
  String? getUserId() {
    return _storageService.getUserId();
  }

  // Get user name
  String? getUserName() {
    return _storageService.getUserName();
  }

  // Get user phone
  String? getUserPhone() {
    return _storageService.getUserPhone();
  }
}
