import 'package:flutter/foundation.dart';
import '../core/services/auth_service.dart';
import '../models/user_model.dart';

/// ViewModel for authentication operations
class AuthViewModel extends ChangeNotifier {
  final AuthService _authService = AuthService.instance;
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;
  
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  
  /// Login with email and password
  Future<bool> login({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _authService.login(
        email: email,
        password: password,
        rememberMe: rememberMe,
      );
      
      if (result.success) {
        _currentUser = result.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Register new user
  Future<bool> register({
    required String email,
    required String password,
    required String name,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    
    try {
      final result = await _authService.register(
        email: email,
        password: password,
        name: name,
      );
      
      if (result.success) {
        _currentUser = result.user;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _errorMessage = result.error;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
  
  /// Logout current user
  Future<void> logout() async {
    await _authService.logout();
    _currentUser = null;
    notifyListeners();
  }
  
  /// Check authentication status
  Future<bool> checkAuthStatus() async {
    return await _authService.isAuthenticated();
  }
  
  /// Clear error message
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
