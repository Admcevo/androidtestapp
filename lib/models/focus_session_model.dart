/// Focus session data model
class FocusSessionModel {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime? endTime;
  final int plannedDuration; // in minutes
  final int? actualDuration; // in minutes
  final bool isActive;
  final int interruptionCount;
  final String? notes;
  
  FocusSessionModel({
    required this.id,
    required this.userId,
    required this.startTime,
    this.endTime,
    required this.plannedDuration,
    this.actualDuration,
    this.isActive = false,
    this.interruptionCount = 0,
    this.notes,
  });
  
  factory FocusSessionModel.fromJson(Map<String, dynamic> json) {
    return FocusSessionModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      startTime: json['startTime'] != null 
          ? DateTime.parse(json['startTime']) 
          : DateTime.now(),
      endTime: json['endTime'] != null 
          ? DateTime.parse(json['endTime']) 
          : null,
      plannedDuration: json['plannedDuration'] ?? 25,
      actualDuration: json['actualDuration'],
      isActive: json['isActive'] ?? false,
      interruptionCount: json['interruptionCount'] ?? 0,
      notes: json['notes'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'plannedDuration': plannedDuration,
      'actualDuration': actualDuration,
      'isActive': isActive,
      'interruptionCount': interruptionCount,
      'notes': notes,
    };
  }
  
  /// Calculate completion rate
  double get completionRate {
    if (actualDuration == null || plannedDuration == 0) return 0.0;
    return (actualDuration! / plannedDuration) * 100;
  }
  
  /// Check if session was successful (>80% completion)
  bool get isSuccessful => completionRate >= 80;
  
  /// Get remaining time in minutes
  int? get remainingMinutes {
    if (!isActive || endTime == null) return null;
    final remaining = endTime!.difference(DateTime.now()).inMinutes;
    return remaining > 0 ? remaining : 0;
  }
}

/// Focus session statistics
class FocusSessionStats {
  final int totalSessions;
  final int completedSessions;
  final int totalMinutes;
  final double averageCompletionRate;
  final int totalInterruptions;
  final DateTime startDate;
  final DateTime endDate;
  
  FocusSessionStats({
    required this.totalSessions,
    required this.completedSessions,
    required this.totalMinutes,
    required this.averageCompletionRate,
    required this.totalInterruptions,
    required this.startDate,
    required this.endDate,
  });
  
  double get successRate => totalSessions > 0 
      ? (completedSessions / totalSessions) * 100 
      : 0.0;
  
  double get averageInterruptionsPerSession => totalSessions > 0 
      ? totalInterruptions / totalSessions 
      : 0.0;
}
