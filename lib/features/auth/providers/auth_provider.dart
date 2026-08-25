import 'package:flutter/foundation.dart';
import '../../../features/users/models/user_model.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/services/api_service.dart';
import '../../../core/services/storage_service.dart';

enum AuthStatus {
  initial,
  loading,
  authenticated,
  unauthenticated,
  error,
}

class AuthProvider with ChangeNotifier {
  final AuthService _authService;
  
  AuthStatus _status = AuthStatus.initial;
  User? _user;
  String? _errorMessage;

  AuthProvider(this._authService) {
    _checkAuthStatus();
  }

  // Getters
  AuthStatus get status => _status;
  User? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoggedIn => _status == AuthStatus.authenticated && _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isSuperAdmin => _user?.isSuperAdmin ?? false;

  // Check if user is already authenticated
  Future<void> _checkAuthStatus() async {
    if (_authService.isLoggedIn()) {
      _status = AuthStatus.loading;
      notifyListeners();

      final result = await _authService.getProfile();
      if (result['success']) {
        _user = User.fromJson(result['user']);
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } else {
      _status = AuthStatus.unauthenticated;
    }
    notifyListeners();
  }

  // Admin Login
  Future<bool> loginAdmin({
    required String phonenumber,
    required String password,
  }) async {
    try {
      _status = AuthStatus.loading;
      _errorMessage = null;
      notifyListeners();

      final result = await _authService.loginAdmin(
        phonenumber: phonenumber,
        password: password,
      );

      if (result['success']) {
        _user = User.fromJson(result['user']);
        _status = AuthStatus.authenticated;
        _errorMessage = null;
        notifyListeners();
        return true;
      } else {
        _status = AuthStatus.error;
        _errorMessage = result['message'];
        notifyListeners();
        return false;
      }
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'حدث خطأ أثناء تسجيل الدخول';
      notifyListeners();
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      _status = AuthStatus.loading;
      notifyListeners();

      await _authService.logout();
      
      _user = null;
      _status = AuthStatus.unauthenticated;
      _errorMessage = null;
      notifyListeners();
    } catch (e) {
      _status = AuthStatus.error;
      _errorMessage = 'حدث خطأ أثناء تسجيل الخروج';
      notifyListeners();
    }
  }

  // Refresh user profile
  Future<void> refreshProfile() async {
    if (!_authService.isLoggedIn()) return;

    final result = await _authService.getProfile();
    if (result['success']) {
      _user = User.fromJson(result['user']);
      notifyListeners();
    }
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Static factory method
  static Future<AuthProvider> create() async {
    final apiService = await ApiService.getInstance();
    final storageService = await StorageService.getInstance();
    final authService = AuthService(apiService, storageService);
    return AuthProvider(authService);
  }
}
