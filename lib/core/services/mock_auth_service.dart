import '../config/app_config.dart';
import 'storage_service.dart';
import '../../models/user_model.dart';
import 'auth_service.dart';

/// Mock authentication service for offline/demo mode
class MockAuthService {
  static final MockAuthService instance = MockAuthService._internal();
  
  factory MockAuthService() => instance;
  
  MockAuthService._internal();
  
  final StorageService _storage = StorageService.instance;
  
  // Mock users database (in-memory)
  final Map<String, Map<String, dynamic>> _mockUsers = {
    'demo@example.com': {
      'id': 'demo-user-123',
      'email': 'demo@example.com',
      'name': 'Demo User',
      'password': 'demo123',
      'createdAt': DateTime.now().toIso8601String(),
    },
    'test@test.com': {
      'id': 'test-user-456',
      'email': 'test@test.com',
      'name': 'Test User',
      'password': 'test123',
      'createdAt': DateTime.now().toIso8601String(),
    },
  };
  
  /// Mock login - works offline
  Future<AuthResult> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if user exists
    if (_mockUsers.containsKey(email)) {
      final userData = _mockUsers[email]!;
      
      // Check password
      if (userData['password'] == password) {
        // Create mock token
        final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
        
        // Create user model
        final user = UserModel(
          id: userData['id'],
          email: userData['email'],
          name: userData['name'],
          createdAt: DateTime.parse(userData['createdAt']),
        );
        
        // Save token and user data
        await _storage.saveToken(token);
        await _storage.saveUserId(user.id);
        await _storage.saveRememberMe(rememberMe);
        
        return AuthResult(success: true, user: user);
      } else {
        return AuthResult(
          success: false,
          error: 'Invalid password',
        );
      }
    } else {
      return AuthResult(
        success: false,
        error: 'User not found',
      );
    }
  }
  
  /// Mock register - creates new user in memory
  Future<AuthResult> register({
    required String email,
    required String password,
    required String name,
  }) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check if user already exists
    if (_mockUsers.containsKey(email)) {
      return AuthResult(
        success: false,
        error: 'Email already registered',
      );
    }
    
    // Create new user
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final userData = {
      'id': userId,
      'email': email,
      'name': name,
      'password': password,
      'createdAt': DateTime.now().toIso8601String(),
    };
    
    _mockUsers[email] = userData;
    
    // Create mock token
    final token = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
    
    // Create user model
    final user = UserModel(
      id: userId,
      email: email,
      name: name,
      createdAt: DateTime.now(),
    );
    
    // Save token and user data
    await _storage.saveToken(token);
    await _storage.saveUserId(user.id);
    
    return AuthResult(success: true, user: user);
  }
  
  /// Logout user
  Future<void> logout() async {
    await _storage.clearTokens();
    await _storage.remove(AppConfig.userIdKey);
  }
  
  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final token = await _storage.getToken();
    return token != null && token.isNotEmpty;
  }
  
  /// Get current user token
  Future<String?> getToken() async {
    return await _storage.getToken();
  }
}
