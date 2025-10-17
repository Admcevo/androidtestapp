/// Application-wide configuration constants
class AppConfig {
  // App Info
  static const String appName = 'Cognitive Load Coach';
  static const String appSlogan = 'Mindful Productivity Awaits';
  static const String appVersion = '1.0.0';
  
  // API Configuration
  static String baseUrl = 'http://localhost:3000/api'; // Default local server
  static const String authEndpoint = '/auth';
  static const String loginEndpoint = '/auth/login';
  static const String registerEndpoint = '/auth/register';
  static const String syncEndpoint = '/sync';
  
  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userIdKey = 'user_id';
  static const String rememberMeKey = 'remember_me';
  static const String themeKey = 'theme_mode';
  static const String apiEndpointKey = 'api_endpoint';
  
  // Feature Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = false;
  
  // Cognitive Load Thresholds
  static const int lowCognitiveLoad = 30;
  static const int mediumCognitiveLoad = 60;
  static const int highCognitiveLoad = 80;
  
  // Focus Mode Durations (in minutes)
  static const List<int> focusModeDurations = [15, 25, 45, 60, 90];
  
  // Notification Categories
  static const List<String> notificationCategories = [
    'Work',
    'Social',
    'Entertainment',
    'News',
    'Shopping',
    'Health',
    'Other',
  ];
  
  // Update API endpoint
  static void updateBaseUrl(String newUrl) {
    baseUrl = newUrl;
  }
}
