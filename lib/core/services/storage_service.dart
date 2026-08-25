import 'package:shared_preferences/shared_preferences.dart';
import '../constants/storage_keys.dart';

class StorageService {
  static StorageService? _instance;
  static SharedPreferences? _preferences;

  StorageService._();

  static Future<StorageService> getInstance() async {
    _instance ??= StorageService._();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  // String operations
  Future<bool> setString(String key, String value) async {
    return await _preferences!.setString(key, value);
  }

  String? getString(String key) {
    return _preferences!.getString(key);
  }

  // Bool operations
  Future<bool> setBool(String key, bool value) async {
    return await _preferences!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _preferences!.getBool(key);
  }

  // Int operations
  Future<bool> setInt(String key, int value) async {
    return await _preferences!.setInt(key, value);
  }

  int? getInt(String key) {
    return _preferences!.getInt(key);
  }

  // Double operations
  Future<bool> setDouble(String key, double value) async {
    return await _preferences!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _preferences!.getDouble(key);
  }

  // List operations
  Future<bool> setStringList(String key, List<String> value) async {
    return await _preferences!.setStringList(key, value);
  }

  List<String>? getStringList(String key) {
    return _preferences!.getStringList(key);
  }

  // Remove operations
  Future<bool> remove(String key) async {
    return await _preferences!.remove(key);
  }

  // Clear all
  Future<bool> clear() async {
    return await _preferences!.clear();
  }

  // Check if key exists
  bool containsKey(String key) {
    return _preferences!.containsKey(key);
  }

  // Authentication helpers
  Future<bool> saveAuthToken(String token) async {
    return await setString(StorageKeys.authToken, token);
  }

  String? getAuthToken() {
    return getString(StorageKeys.authToken);
  }

  Future<bool> saveUserId(String userId) async {
    return await setString(StorageKeys.userId, userId);
  }

  String? getUserId() {
    return getString(StorageKeys.userId);
  }

  Future<bool> saveUserRole(String role) async {
    return await setString(StorageKeys.userRole, role);
  }

  String? getUserRole() {
    return getString(StorageKeys.userRole);
  }

  Future<bool> saveUserPhone(String phone) async {
    return await setString(StorageKeys.userPhone, phone);
  }

  String? getUserPhone() {
    return getString(StorageKeys.userPhone);
  }

  Future<bool> saveUserName(String name) async {
    return await setString(StorageKeys.userName, name);
  }

  String? getUserName() {
    return getString(StorageKeys.userName);
  }

  Future<bool> setLoggedIn(bool value) async {
    return await setBool(StorageKeys.isLoggedIn, value);
  }

  bool isLoggedIn() {
    return getBool(StorageKeys.isLoggedIn) ?? false;
  }

  // Theme helpers
  Future<bool> saveDarkMode(bool isDark) async {
    return await setBool(StorageKeys.isDarkMode, isDark);
  }

  bool isDarkMode() {
    return getBool(StorageKeys.isDarkMode) ?? false;
  }

  // FCM Token helpers
  Future<bool> saveFcmToken(String token) async {
    await setInt(StorageKeys.fcmTokenTimestamp, DateTime.now().millisecondsSinceEpoch);
    return await setString(StorageKeys.fcmToken, token);
  }

  String? getFcmToken() {
    return getString(StorageKeys.fcmToken);
  }

  // Branding helpers
  Future<bool> saveBrandingLogo(String url) async {
    return await setString(StorageKeys.brandingLogo, url);
  }

  String? getBrandingLogo() {
    return getString(StorageKeys.brandingLogo);
  }

  Future<bool> saveBrandingName(String name) async {
    return await setString(StorageKeys.brandingName, name);
  }

  String? getBrandingName() {
    return getString(StorageKeys.brandingName);
  }

  Future<bool> saveBrandingColors(String primary, String secondary) async {
    await setString(StorageKeys.brandingPrimaryColor, primary);
    return await setString(StorageKeys.brandingSecondaryColor, secondary);
  }

  String? getPrimaryColor() {
    return getString(StorageKeys.brandingPrimaryColor);
  }

  String? getSecondaryColor() {
    return getString(StorageKeys.brandingSecondaryColor);
  }

  // Theme mode
  Future<bool> saveThemeMode(bool isDark) async {
    return await setBool(StorageKeys.themeMode, isDark);
  }

  bool getThemeMode() {
    return getBool(StorageKeys.themeMode) ?? false;
  }

  // Clear user session
  Future<void> clearSession() async {
    await remove(StorageKeys.authToken);
    await remove(StorageKeys.userId);
    await remove(StorageKeys.userRole);
    await remove(StorageKeys.userPhone);
    await remove(StorageKeys.userName);
    await setLoggedIn(false);
  }
}
