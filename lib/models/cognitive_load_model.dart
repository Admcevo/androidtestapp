/// Cognitive load data model
class CognitiveLoadModel {
  final String id;
  final String userId;
  final int loadScore; // 0-100
  final DateTime timestamp;
  final Map<String, dynamic> factors;
  
  CognitiveLoadModel({
    required this.id,
    required this.userId,
    required this.loadScore,
    required this.timestamp,
    required this.factors,
  });
  
  factory CognitiveLoadModel.fromJson(Map<String, dynamic> json) {
    return CognitiveLoadModel(
      id: json['id'] ?? '',
      userId: json['userId'] ?? '',
      loadScore: json['loadScore'] ?? 0,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp']) 
          : DateTime.now(),
      factors: json['factors'] ?? {},
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'loadScore': loadScore,
      'timestamp': timestamp.toIso8601String(),
      'factors': factors,
    };
  }
  
  /// Get load level description
  String get loadLevel {
    if (loadScore < 30) return 'Low';
    if (loadScore < 60) return 'Moderate';
    if (loadScore < 80) return 'High';
    return 'Very High';
  }
  
  /// Get load level color
  String get loadLevelColor {
    if (loadScore < 30) return '#4CAF50'; // Green
    if (loadScore < 60) return '#42A5F5'; // Blue
    if (loadScore < 80) return '#FFA726'; // Orange
    return '#EF5350'; // Red
  }
}

/// Daily cognitive load summary
class DailyCognitiveLoad {
  final DateTime date;
  final int averageLoad;
  final int peakLoad;
  final int lowestLoad;
  final List<CognitiveLoadModel> readings;
  
  DailyCognitiveLoad({
    required this.date,
    required this.averageLoad,
    required this.peakLoad,
    required this.lowestLoad,
    required this.readings,
  });
  
  factory DailyCognitiveLoad.fromReadings(DateTime date, List<CognitiveLoadModel> readings) {
    if (readings.isEmpty) {
      return DailyCognitiveLoad(
        date: date,
        averageLoad: 0,
        peakLoad: 0,
        lowestLoad: 0,
        readings: [],
      );
    }
    
    final loads = readings.map((r) => r.loadScore).toList();
    final sum = loads.reduce((a, b) => a + b);
    
    return DailyCognitiveLoad(
      date: date,
      averageLoad: (sum / loads.length).round(),
      peakLoad: loads.reduce((a, b) => a > b ? a : b),
      lowestLoad: loads.reduce((a, b) => a < b ? a : b),
      readings: readings,
    );
  }
}
