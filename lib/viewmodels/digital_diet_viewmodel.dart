import 'package:flutter/foundation.dart';
import '../models/digital_diet_model.dart';
import '../models/screen_time_model.dart';

/// ViewModel for digital diet coach
class DigitalDietViewModel extends ChangeNotifier {
  bool _isLoading = false;
  WeeklyDigitalDietSummary? _weeklySummary;
  List<ScreenTimeModel> _weeklyScreenTime = [];
  List<DigitalDietRecommendation> _recommendations = [];
  
  bool get isLoading => _isLoading;
  WeeklyDigitalDietSummary? get weeklySummary => _weeklySummary;
  List<ScreenTimeModel> get weeklyScreenTime => _weeklyScreenTime;
  List<DigitalDietRecommendation> get recommendations => _recommendations;
  
  /// Load weekly summary
  Future<void> loadWeeklySummary() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate API call - replace with actual API call
      await Future.delayed(const Duration(seconds: 1));
      
      final now = DateTime.now();
      final weekStart = now.subtract(Duration(days: now.weekday - 1));
      final weekEnd = weekStart.add(const Duration(days: 6));
      
      // Mock data for demonstration
      _weeklyScreenTime = List.generate(7, (index) {
        final date = weekStart.add(Duration(days: index));
        return ScreenTimeModel(
          id: index.toString(),
          userId: 'user1',
          date: date,
          totalMinutes: 180 + (index * 20),
          appUsage: {
            'Instagram': 60 + (index * 5),
            'Chrome': 45 + (index * 3),
            'YouTube': 30 + (index * 2),
            'Gmail': 25 + (index * 2),
            'WhatsApp': 20 + index,
          },
          pickupCount: 50 + (index * 5),
        );
      });
      
      _recommendations = [
        DigitalDietRecommendation(
          id: '1',
          userId: 'user1',
          title: 'Reduce Instagram usage',
          description: 'You spent 8 hours on Instagram this week. Try to limit it to 5 hours.',
          category: 'screen_time',
          priority: 5,
          createdAt: now,
        ),
        DigitalDietRecommendation(
          id: '2',
          userId: 'user1',
          title: 'Schedule focus sessions',
          description: 'Add 2 focus sessions daily to improve productivity.',
          category: 'focus',
          priority: 4,
          createdAt: now,
        ),
        DigitalDietRecommendation(
          id: '3',
          userId: 'user1',
          title: 'Better sleep hygiene',
          description: 'Avoid screens 1 hour before bedtime.',
          category: 'sleep',
          priority: 4,
          createdAt: now,
        ),
      ];
      
      final totalScreenTime = _weeklyScreenTime.fold<int>(
        0, 
        (sum, item) => sum + item.totalMinutes,
      );
      
      _weeklySummary = WeeklyDigitalDietSummary(
        weekStart: weekStart,
        weekEnd: weekEnd,
        totalScreenTime: totalScreenTime,
        averageDailyScreenTime: (totalScreenTime / 7).round(),
        totalNotifications: 320,
        totalFocusSessions: 12,
        averageCognitiveLoad: 52,
        recommendations: _recommendations,
      );
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Get screen time trend (increasing/decreasing)
  String getScreenTimeTrend() {
    if (_weeklyScreenTime.length < 2) return 'stable';
    
    final firstHalf = _weeklyScreenTime.take(3).fold<int>(
      0, 
      (sum, item) => sum + item.totalMinutes,
    );
    
    final secondHalf = _weeklyScreenTime.skip(4).fold<int>(
      0, 
      (sum, item) => sum + item.totalMinutes,
    );
    
    if (secondHalf > firstHalf * 1.1) return 'increasing';
    if (secondHalf < firstHalf * 0.9) return 'decreasing';
    return 'stable';
  }
  
  /// Mark recommendation as completed
  Future<void> completeRecommendation(String recommendationId) async {
    final index = _recommendations.indexWhere((r) => r.id == recommendationId);
    if (index != -1) {
      _recommendations.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Refresh data
  Future<void> refresh() async {
    await loadWeeklySummary();
  }
}
