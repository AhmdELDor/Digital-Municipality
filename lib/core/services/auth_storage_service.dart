import 'package:get_storage/get_storage.dart';
import '../models/user_model.dart';
import 'dart:convert';

class AuthStorageService {
  static final AuthStorageService _instance = AuthStorageService._internal();
  late GetStorage _box;

  // Storage keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';
  static const String _rememberMeKey = 'remember_me';
  static const String _savedPhoneKey = 'saved_phone';

  factory AuthStorageService() {
    return _instance;
  }

  AuthStorageService._internal() {
    _box = GetStorage();
  }

  // Save auth token
  Future<void> saveToken(String token) async {
    await _box.write(_tokenKey, token);
  }

  // Get auth token
  Future<String?> getToken() async {
    return _box.read(_tokenKey);
  }

  // Save user data
  Future<void> saveUser(UserModel user) async {
    await _box.write(_userKey, jsonEncode(user.toJson()));
  }

  // Get user data
  Future<UserModel?> getUser() async {
    final userData = _box.read(_userKey);
    if (userData != null) {
      return UserModel.fromJson(jsonDecode(userData));
    }
    return null;
  }

  // Save remember me preference
  Future<void> saveRememberMe(bool remember) async {
    await _box.write(_rememberMeKey, remember);
  }

  // Get remember me preference
  bool getRememberMe() {
    return _box.read(_rememberMeKey) ?? false;
  }

  // Save phone number (when remember me is checked)
  Future<void> saveSavedPhone(String phone) async {
    await _box.write(_savedPhoneKey, phone);
  }

  // Get saved phone number
  String? getSavedPhone() {
    return _box.read(_savedPhoneKey);
  }

  // Check if user is authenticated
  bool isAuthenticated() {
    return _box.read(_tokenKey) != null;
  }

  // Clear all auth data (logout)
  Future<void> clearAuth() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userKey);
    // Keep remember me preference and saved phone if remember me is true
    if (!getRememberMe()) {
      await _box.remove(_savedPhoneKey);
    }
  }

  // Clear everything including remember me
  Future<void> clearAll() async {
    await _box.remove(_tokenKey);
    await _box.remove(_userKey);
    await _box.remove(_rememberMeKey);
    await _box.remove(_savedPhoneKey);
  }
}
