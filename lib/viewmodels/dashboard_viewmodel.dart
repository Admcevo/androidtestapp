import 'package:flutter/foundation.dart';
import '../models/cognitive_load_model.dart';
import '../models/digital_diet_model.dart';
import '../models/focus_session_model.dart';

/// ViewModel for dashboard screen
class DashboardViewModel extends ChangeNotifier {
  bool _isLoading = false;
  CognitiveLoadModel? _currentCognitiveLoad;
  List<DigitalDietRecommendation> _todayRecommendations = [];
  FocusSessionModel? _activeFocusSession;
  int _todayScreenTime = 0;
  int _todayNotificationCount = 0;
  
  bool get isLoading => _isLoading;
  CognitiveLoadModel? get currentCognitiveLoad => _currentCognitiveLoad;
  List<DigitalDietRecommendation> get todayRecommendations => _todayRecommendations;
  FocusSessionModel? get activeFocusSession => _activeFocusSession;
  int get todayScreenTime => _todayScreenTime;
  int get todayNotificationCount => _todayNotificationCount;
  
  /// Load dashboard data
  Future<void> loadDashboardData() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      // Simulate API calls - replace with actual API calls
      await Future.delayed(const Duration(seconds: 1));
      
      // Mock data for demonstration
      _currentCognitiveLoad = CognitiveLoadModel(
        id: '1',
        userId: 'user1',
        loadScore: 45,
        timestamp: DateTime.now(),
        factors: {
          'notifications': 30,
          'screenTime': 20,
          'focusSessions': 10,
          'sleep': 15,
        },
      );
      
      _todayRecommendations = [
        DigitalDietRecommendation(
          id: '1',
          userId: 'user1',
          title: 'Take a 15-minute break',
          description: 'You\'ve been working for 2 hours straight. Time for a short break!',
          category: 'focus',
          priority: 4,
          createdAt: DateTime.now(),
        ),
        DigitalDietRecommendation(
          id: '2',
          userId: 'user1',
          title: 'Reduce social media time',
          description: 'You\'ve spent 45 minutes on social media today. Consider limiting it.',
          category: 'screen_time',
          priority: 3,
          createdAt: DateTime.now(),
        ),
        DigitalDietRecommendation(
          id: '3',
          userId: 'user1',
          title: 'Enable focus mode',
          description: 'Start a focus session to minimize distractions.',
          category: 'notifications',
          priority: 5,
          createdAt: DateTime.now(),
        ),
      ];
      
      _todayScreenTime = 180; // 3 hours in minutes
      _todayNotificationCount = 47;
      
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
    }
  }
  
  /// Start a focus session
  Future<void> startFocusSession(int durationMinutes) async {
    final endTime = DateTime.now().add(Duration(minutes: durationMinutes));
    
    _activeFocusSession = FocusSessionModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: 'user1',
      startTime: DateTime.now(),
      endTime: endTime,
      plannedDuration: durationMinutes,
      isActive: true,
    );
    
    notifyListeners();
    
    // TODO: Implement actual focus mode logic (DND, notification filtering, etc.)
  }
  
  /// End active focus session
  Future<void> endFocusSession() async {
    if (_activeFocusSession != null) {
      final actualDuration = DateTime.now().difference(_activeFocusSession!.startTime).inMinutes;
      
      // TODO: Save session to database
      
      _activeFocusSession = null;
      notifyListeners();
    }
  }
  
  /// Mark recommendation as completed
  Future<void> completeRecommendation(String recommendationId) async {
    final index = _todayRecommendations.indexWhere((r) => r.id == recommendationId);
    if (index != -1) {
      _todayRecommendations.removeAt(index);
      notifyListeners();
    }
  }
  
  /// Refresh dashboard data
  Future<void> refresh() async {
    await loadDashboardData();
  }
}
