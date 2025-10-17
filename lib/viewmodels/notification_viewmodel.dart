import 'package:flutter/foundation.dart';
import '../models/notification_model.dart';
import '../core/config/app_config.dart';

/// ViewModel for notification management
class NotificationViewModel extends ChangeNotifier {
  bool _isLoading = false;
  List<NotificationModel> _notifications = [];
  Map<String, bool> _categoryFilters = {};
  NotificationStats? _stats;
  
  bool get isLoading => _isLoading;
  List<NotificationModel> get notifications => _notifications;
  Map<String, bool> get categoryFilters => _categoryFilters;
  NotificationStats? get stats => _stats;
  
  NotificationViewModel() {
    _initializeCategoryFilters();
  }
  
  /// Initialize category filters
  void _initializeCategoryFilters() {
    for (final category in AppConfig.notificationCategories) {
      _categoryFilters[category] = false;
    }
  }
  
  /// Load notifications
  Future<void> loadNotifications() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate API call - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demonstration
      _notifications = [
        NotificationModel(
          id: '1',
          userId: 'user1',
          appName: 'Instagram',
          category: 'Social',
          title: 'New follower',
          body: 'John Doe started following you',
          timestamp: DateTime.now().subtract(const Duration(minutes: 5)),
          priority: 2,
        ),
        NotificationModel(
          id: '2',
          userId: 'user1',
          appName: 'Gmail',
          category: 'Work',
          title: 'New email from boss',
          body: 'Meeting at 3 PM',
          timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
          priority: 5,
        ),
        NotificationModel(
          id: '3',
          userId: 'user1',
          appName: 'YouTube',
          category: 'Entertainment',
          title: 'New video uploaded',
          body: 'Your favorite channel posted a new video',
          timestamp: DateTime.now().subtract(const Duration(hours: 1)),
          priority: 1,
          isFiltered: true,
        ),
      ];
      
      _calculateStats();
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Toggle category filter
  Future<void> toggleCategoryFilter(String category) async {
    _categoryFilters[category] = !(_categoryFilters[category] ?? false);
    notifyListeners();
    
    // TODO: Save filter preferences and apply to notification system
  }
  
  /// Get filtered notifications
  List<NotificationModel> getFilteredNotifications() {
    return _notifications.where((notification) {
      final isFiltered = _categoryFilters[notification.category] ?? false;
      return !isFiltered;
    }).toList();
  }
  
  /// Calculate notification statistics
  void _calculateStats() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    
    final todayNotifications = _notifications.where((n) => 
      n.timestamp.isAfter(startOfDay)
    ).toList();
    
    final categoryBreakdown = <String, int>{};
    final appBreakdown = <String, int>{};
    int filteredCount = 0;
    
    for (final notification in todayNotifications) {
      categoryBreakdown[notification.category] = 
          (categoryBreakdown[notification.category] ?? 0) + 1;
      appBreakdown[notification.appName] = 
          (appBreakdown[notification.appName] ?? 0) + 1;
      
      if (notification.isFiltered) {
        filteredCount++;
      }
    }
    
    _stats = NotificationStats(
      totalCount: todayNotifications.length,
      filteredCount: filteredCount,
      categoryBreakdown: categoryBreakdown,
      appBreakdown: appBreakdown,
      startDate: startOfDay,
      endDate: now,
    );
  }
  
  /// Refresh notifications
  Future<void> refresh() async {
    await loadNotifications();
  }
}
