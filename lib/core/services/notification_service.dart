import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';

/// Service for managing local notifications and focus mode reminders
class NotificationService {
  static final NotificationService instance = NotificationService._internal();
  
  factory NotificationService() => instance;
  
  NotificationService._internal();
  
  final FlutterLocalNotificationsPlugin _notifications = 
      FlutterLocalNotificationsPlugin();
  
  bool _initialized = false;
  
  /// Initialize notification service
  Future<void> init() async {
    if (_initialized) return;
    
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _notifications.initialize(
      settings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
    );
    
    _initialized = true;
  }
  
  /// Request notification permissions
  Future<bool> requestPermissions() async {
    if (await Permission.notification.isGranted) {
      return true;
    }
    
    final status = await Permission.notification.request();
    return status.isGranted;
  }
  
  /// Show a simple notification
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'cognitive_load_channel',
      'Cognitive Load Notifications',
      channelDescription: 'Notifications for cognitive load management',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF6A0DAD),
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  /// Schedule a notification
  Future<void> scheduleNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'cognitive_load_channel',
      'Cognitive Load Notifications',
      channelDescription: 'Notifications for cognitive load management',
      importance: Importance.high,
      priority: Priority.high,
      color: Color(0xFF6A0DAD),
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    // Note: For full scheduling support, you may need to use timezone package
    // This is a simplified version
    await _notifications.show(id, title, body, details, payload: payload);
  }
  
  /// Show focus mode start notification
  Future<void> showFocusModeNotification(int durationMinutes) async {
    await showNotification(
      id: 1000,
      title: '🎯 Focus Mode Active',
      body: 'Stay focused for the next $durationMinutes minutes!',
    );
  }
  
  /// Show focus mode end notification
  Future<void> showFocusModeEndNotification() async {
    await showNotification(
      id: 1001,
      title: '✅ Focus Session Complete',
      body: 'Great job! Time for a break.',
    );
  }
  
  /// Show cognitive load warning
  Future<void> showCognitiveLoadWarning(int loadScore) async {
    String message;
    if (loadScore >= 80) {
      message = 'Your cognitive load is very high. Consider taking a break.';
    } else if (loadScore >= 60) {
      message = 'Your cognitive load is elevated. Time to slow down.';
    } else {
      message = 'Your cognitive load is moderate. Stay mindful.';
    }
    
    await showNotification(
      id: 2000,
      title: '⚠️ Cognitive Load Alert',
      body: message,
    );
  }
  
  /// Cancel a specific notification
  Future<void> cancelNotification(int id) async {
    await _notifications.cancel(id);
  }
  
  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
  
  /// Handle notification tap
  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap - can be used to navigate to specific screens
    final payload = response.payload;
    if (payload != null) {
      // Parse payload and navigate accordingly
    }
  }
}
