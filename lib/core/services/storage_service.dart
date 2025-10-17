import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../config/app_config.dart';

/// Service for managing local storage (secure and non-secure)
class StorageService {
  static final StorageService instance = StorageService._internal();
  
  factory StorageService() => instance;
  
  StorageService._internal();
  
  late SharedPreferences _prefs;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
  );
  
  /// Initialize storage service
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }
  
  // ===== Secure Storage (for sensitive data like tokens) =====
  
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: AppConfig.tokenKey, value: token);
  }
  
  Future<String?> getToken() async {
    return await _secureStorage.read(key: AppConfig.tokenKey);
  }
  
  Future<void> saveRefreshToken(String token) async {
    await _secureStorage.write(key: AppConfig.refreshTokenKey, value: token);
  }
  
  Future<String?> getRefreshToken() async {
    return await _secureStorage.read(key: AppConfig.refreshTokenKey);
  }
  
  Future<void> clearTokens() async {
    await _secureStorage.delete(key: AppConfig.tokenKey);
    await _secureStorage.delete(key: AppConfig.refreshTokenKey);
  }
  
  // ===== Regular Storage (for non-sensitive data) =====
  
  Future<void> saveUserId(String userId) async {
    await _prefs.setString(AppConfig.userIdKey, userId);
  }
  
  String? getUserId() {
    return _prefs.getString(AppConfig.userIdKey);
  }
  
  Future<void> saveRememberMe(bool value) async {
    await _prefs.setBool(AppConfig.rememberMeKey, value);
  }
  
  bool getRememberMe() {
    return _prefs.getBool(AppConfig.rememberMeKey) ?? false;
  }
  
  Future<void> saveThemeMode(String mode) async {
    await _prefs.setString(AppConfig.themeKey, mode);
  }
  
  String getThemeMode() {
    return _prefs.getString(AppConfig.themeKey) ?? 'system';
  }
  
  Future<void> saveApiEndpoint(String endpoint) async {
    await _prefs.setString(AppConfig.apiEndpointKey, endpoint);
    AppConfig.updateBaseUrl(endpoint);
  }
  
  String getApiEndpoint() {
    return _prefs.getString(AppConfig.apiEndpointKey) ?? AppConfig.baseUrl;
  }
  
  // ===== Generic Methods =====
  
  Future<void> saveString(String key, String value) async {
    await _prefs.setString(key, value);
  }
  
  String? getString(String key) {
    return _prefs.getString(key);
  }
  
  Future<void> saveInt(String key, int value) async {
    await _prefs.setInt(key, value);
  }
  
  int? getInt(String key) {
    return _prefs.getInt(key);
  }
  
  Future<void> saveBool(String key, bool value) async {
    await _prefs.setBool(key, value);
  }
  
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }
  
  Future<void> saveDouble(String key, double value) async {
    await _prefs.setDouble(key, value);
  }
  
  double? getDouble(String key) {
    return _prefs.getDouble(key);
  }
  
  Future<void> remove(String key) async {
    await _prefs.remove(key);
  }
  
  Future<void> clearAll() async {
    await _prefs.clear();
    await _secureStorage.deleteAll();
  }
}
