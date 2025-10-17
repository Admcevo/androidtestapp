/// Digital diet recommendation model
class DigitalDietRecommendation {
  final String id;
  final String userId;
  final String title;
  final String description;
  final String category; // 'screen_time', 'notifications', 'focus', 'sleep'
  final int priority; // 1-5
  final DateTime createdAt;
  final bool isCompleted;
  final String? actionUrl;
  
  DigitalDietRecommendation({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.category,
    this.priority = 3,
    required this.createdAt,
    this.isCompleted = false,
    this.actionUrl,
  });
  
  factory DigitalDietRecommendation.fromJson(Map<String, dynamic> json) {
    return DigitalDietRecommendation(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? 'general',
      priority: json['priority'] ?? 3,
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : DateTime.now(),
      isCompleted: json['isCompleted'] ?? false,
      actionUrl: json['actionUrl'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'description': description,
      'category': category,
      'priority': priority,
      'createdAt': createdAt.toIso8601String(),
      'isCompleted': isCompleted,
      'actionUrl': actionUrl,
    };
  }
  
  /// Get category icon
  String get categoryIcon {
    switch (category) {
      case 'screen_time':
        return '📱';
      case 'notifications':
        return '🔔';
      case 'focus':
        return '🎯';
      case 'sleep':
        return '😴';
      default:
        return '💡';
    }
  }
}

/// Screen time data model
class ScreenTimeModel {
  final String id;
  final String userId;
  final DateTime date;
  final int totalMinutes;
  final Map<String, int> appUsage; // app name -> minutes
  final int pickupCount;
  
  ScreenTimeModel({
    required this.id,
    required this.userId,
    required this.date,
    required this.totalMinutes,
    required this.appUsage,
    required this.pickupCount,
  });
  
  factory ScreenTimeModel.fromJson(Map<String, dynamic> json) {
    return ScreenTimeModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      date: json['date'] != null 
          ? DateTime.parse(json['date']) 
          : DateTime.now(),
      totalMinutes: json['totalMinutes'] ?? 0,
      appUsage: Map<String, int>.from(json['appUsage'] ?? {}),
      pickupCount: json['pickupCount'] ?? 0,
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'date': date.toIso8601String(),
      'totalMinutes': totalMinutes,
      'appUsage': appUsage,
      'pickupCount': pickupCount,
    };
  }
  
  /// Get formatted total time
  String get formattedTotalTime {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    return '${hours}h ${minutes}m';
  }
  
  /// Get top apps by usage
  List<MapEntry<String, int>> get topApps {
    final entries = appUsage.entries.toList();
    entries.sort((a, b) => b.value.compareTo(a.value));
    return entries.take(5).toList();
  }
}

/// Weekly digital diet summary
class WeeklyDigitalDietSummary {
  final DateTime weekStart;
  final DateTime weekEnd;
  final int totalScreenTime; // in minutes
  final int averageDailyScreenTime;
  final int totalNotifications;
  final int totalFocusSessions;
  final int averageCognitiveLoad;
  final List<DigitalDietRecommendation> recommendations;
  
  WeeklyDigitalDietSummary({
    required this.weekStart,
    required this.weekEnd,
    required this.totalScreenTime,
    required this.averageDailyScreenTime,
    required this.totalNotifications,
    required this.totalFocusSessions,
    required this.averageCognitiveLoad,
    required this.recommendations,
  });
  
  String get formattedTotalScreenTime {
    final hours = totalScreenTime ~/ 60;
    final minutes = totalScreenTime % 60;
    return '${hours}h ${minutes}m';
  }
  
  String get formattedAverageDailyScreenTime {
    final hours = averageDailyScreenTime ~/ 60;
    final minutes = averageDailyScreenTime % 60;
    return '${hours}h ${minutes}m';
  }
}
