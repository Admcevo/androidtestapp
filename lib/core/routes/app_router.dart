import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../ui/screens/splash_screen.dart';
import '../../ui/screens/auth/login_screen.dart';
import '../../ui/screens/auth/register_screen.dart';
import '../../ui/screens/dashboard/dashboard_screen.dart';
import '../../ui/screens/notifications/notification_management_screen.dart';
import '../../ui/screens/digital_diet/digital_diet_screen.dart';
import '../../ui/screens/profile/profile_screen.dart';
import '../../ui/screens/profile/settings_screen.dart';
import '../../core/services/storage_service.dart';

/// Application routing configuration using GoRouter
class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    redirect: (context, state) async {
      final isLoggedIn = await _checkAuthStatus();
      final isOnAuthPage = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register';
      final isOnSplash = state.matchedLocation == '/splash';
      
      // Allow splash screen to show
      if (isOnSplash) return null;
      
      // Redirect to dashboard if logged in and trying to access auth pages
      if (isLoggedIn && isOnAuthPage) {
        return '/dashboard';
      }
      
      // Redirect to login if not logged in and trying to access protected pages
      if (!isLoggedIn && !isOnAuthPage) {
        return '/login';
      }
      
      return null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/dashboard',
        name: 'dashboard',
        builder: (context, state) => const DashboardScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationManagementScreen(),
      ),
      GoRoute(
        path: '/digital-diet',
        name: 'digital-diet',
        builder: (context, state) => const DigitalDietScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Page not found: ${state.matchedLocation}'),
      ),
    ),
  );
  
  static Future<bool> _checkAuthStatus() async {
    final token = await StorageService.instance.getToken();
    return token != null && token.isNotEmpty;
  }
}
