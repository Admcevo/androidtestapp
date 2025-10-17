import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import '../config/app_config.dart';
import 'storage_service.dart';
import 'mock_auth_service.dart';
import '../../models/user_model.dart';

/// Service for handling authentication operations
class AuthService {
  static final AuthService instance = AuthService._internal();
  
  factory AuthService() => instance;
  
  AuthService._internal();
  
  final StorageService _storage = StorageService.instance;
  final MockAuthService _mockAuth = MockAuthService.instance;
  bool _useMockMode = false;
  
  /// Login with email and password
  Future<AuthResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // If already in mock mode, use mock auth
    if (_useMockMode) {
      return await _mockAuth.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
    }
    
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.loginEndpoint}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final user = UserModel.fromJson(data['user']);
        
        // Save token and user data
        await _storage.saveToken(token);
        await _storage.saveUserId(user.id);
        await _storage.saveRememberMe(rememberMe);
        
        if (data.containsKey('refreshToken')) {
          await _storage.saveRefreshToken(data['refreshToken']);
        }
        
        return AuthResult(success: true, user: user);
      } else {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          error: error['message'] ?? 'Login failed',
        );
      }
    } catch (e) {
      // Backend not available - switch to mock mode
      _useMockMode = true;
      print('⚠️ Backend unavailable, switching to DEMO MODE');
      return await _mockAuth.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
    }
  }
  
  /// Register new user
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // If already in mock mode, use mock auth
    if (_useMockMode) {
      return await _mockAuth.register(
        email: email,
        password: password,
        name: name,
      );
    }
    
    try {
      final url = Uri.parse('${AppConfig.baseUrl}${AppConfig.registerEndpoint}');
      
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
          'password': password,
          'name': name,
        }),
      ).timeout(const Duration(seconds: 5));
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final token = data['token'] as String;
        final user = UserModel.fromJson(data['user']);
        
        // Save token and user data
        await _storage.saveToken(token);
        await _storage.saveUserId(user.id);
        
        if (data.containsKey('refreshToken')) {
          await _storage.saveRefreshToken(data['refreshToken']);
        }
        
        return AuthResult(success: true, user: user);
      } else {
        final error = jsonDecode(response.body);
        return AuthResult(
          success: false,
          error: error['message'] ?? 'Registration failed',
        );
      }
    } catch (e) {
      // Backend not available - switch to mock mode
      _useMockMode = true;
      print('⚠️ Backend unavailable, switching to DEMO MODE');
      return await _mockAuth.register(
        email: email,
        password: password,
        name: name,
      );
    }
  }
  
  /// Logout user
  Future<void> logout() async {
    await _storage.clearTokens();
    await _storage.remove(AppConfig.userIdKey);
  }
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    if (token == null || token.isEmpty) return false;
    
    // Check if token is expired
    try {
      return !JwtDecoder.isExpired(token);
    } catch (e) {
      return false;
    }
  }
  
  /// Get current user token
  Future<String?> getToken() async {
    return await _storage.getToken();
  }
  
  /// Refresh authentication token
  Future<bool> refreshToken() async {
    try {
      final refreshToken = await _storage.getRefreshToken();
      if (refreshToken == null) return false;
      
      final url = Uri.parse('${AppConfig.baseUrl}/auth/refresh');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'refreshToken': refreshToken}),
      );
      
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        await _storage.saveToken(data['token']);
        return true;
      }
      
      return false;
    } catch (e) {
      return false;
    }
  }
}

/// Authentication result model
class AuthResult {
  final bool success;
  final UserModel? user;
  final String? error;
  
  AuthResult({
    required this.success,
    this.user,
    this.error,
  });
}
