/// Notification data model
class NotificationModel {
  final String id;
  final String userId;
  final String appName;
  final String category;
  final String title;
  final String? body;
  final DateTime timestamp;
  final bool isFiltered;
  final int priority; // 1-5
  
  NotificationModel({
    required this.id,
    required this.userId,
    required this.appName,
    required this.category,
    required this.title,
    this.body,
    required this.timestamp,
    this.isFiltered = false,
    this.priority = 3,
  });
  
  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      appName: json['appName'] ?? '',
      category: json['category'] ?? 'Other',
      title: json['title'] ?? '',
      body: json['body'],
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      isFiltered: json['isFiltered'] ?? false,
      priority: json['priority'] ?? 3,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'appName': appName,
      'category': category,
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'isFiltered': isFiltered,
      'priority': priority,
    };
  }
}

/// Notification statistics model
class NotificationStats {
  final int totalCount;
  final int filteredCount;
  final Map<String, int> categoryBreakdown;
  final Map<String, int> appBreakdown;
  final DateTime startDate;
  final DateTime endDate;
  
  NotificationStats({
    required this.totalCount,
    required this.filteredCount,
    required this.categoryBreakdown,
    required this.appBreakdown,
    required this.startDate,
    required this.endDate,
  });
  
  int get allowedCount => totalCount - filteredCount;
  
  double get filterRate => totalCount > 0 
      ? (filteredCount / totalCount) * 100 
      : 0.0;
}
