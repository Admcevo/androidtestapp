import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../models/cognitive_load_model.dart';
import '../../models/notification_model.dart';
import '../../models/focus_session_model.dart';
import '../../models/screen_time_model.dart';

/// SQLite database helper for local data persistence
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'cognitive_load_coach.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // Cognitive Load table
    await db.execute('''
      CREATE TABLE cognitive_loads (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        load_score INTEGER NOT NULL,
        timestamp TEXT NOT NULL,
        factors TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        app_name TEXT NOT NULL,
        category TEXT NOT NULL,
        title TEXT NOT NULL,
        body TEXT,
        timestamp TEXT NOT NULL,
        is_filtered INTEGER DEFAULT 0,
        priority INTEGER DEFAULT 3,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Focus Sessions table
    await db.execute('''
      CREATE TABLE focus_sessions (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        start_time TEXT NOT NULL,
        end_time TEXT,
        planned_duration INTEGER NOT NULL,
        actual_duration INTEGER,
        is_active INTEGER DEFAULT 0,
        interruption_count INTEGER DEFAULT 0,
        notes TEXT,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Screen Time table
    await db.execute('''
      CREATE TABLE screen_time (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        date TEXT NOT NULL,
        total_minutes INTEGER NOT NULL,
        app_usage TEXT NOT NULL,
        pickup_count INTEGER NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Create indexes for better query performance
    await db.execute('CREATE INDEX idx_cognitive_loads_user_id ON cognitive_loads(user_id)');
    await db.execute('CREATE INDEX idx_cognitive_loads_timestamp ON cognitive_loads(timestamp)');
    await db.execute('CREATE INDEX idx_notifications_user_id ON notifications(user_id)');
    await db.execute('CREATE INDEX idx_notifications_timestamp ON notifications(timestamp)');
    await db.execute('CREATE INDEX idx_focus_sessions_user_id ON focus_sessions(user_id)');
    await db.execute('CREATE INDEX idx_screen_time_user_id ON screen_time(user_id)');
    await db.execute('CREATE INDEX idx_screen_time_date ON screen_time(date)');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    // Handle database migrations here
  }

  // ===== Cognitive Load Operations =====

  Future<int> insertCognitiveLoad(CognitiveLoadModel load) async {
    final db = await database;
    return await db.insert('cognitive_loads', {
      'id': load.id,
      'user_id': load.userId,
      'load_score': load.loadScore,
      'timestamp': load.timestamp.toIso8601String(),
      'factors': load.factors.toString(),
      'synced': 0,
    });
  }

  Future<List<CognitiveLoadModel>> getCognitiveLoads(String userId, {int? limit}) async {
    final db = await database;
    final maps = await db.query(
      'cognitive_loads',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) => CognitiveLoadModel.fromJson({
      'id': map['id'],
      'userId': map['user_id'],
      'loadScore': map['load_score'],
      'timestamp': map['timestamp'],
      'factors': {}, // Parse from string if needed
    })).toList();
  }

  // ===== Notification Operations =====

  Future<int> insertNotification(NotificationModel notification) async {
    final db = await database;
    return await db.insert('notifications', {
      'id': notification.id,
      'user_id': notification.userId,
      'app_name': notification.appName,
      'category': notification.category,
      'title': notification.title,
      'body': notification.body,
      'timestamp': notification.timestamp.toIso8601String(),
      'is_filtered': notification.isFiltered ? 1 : 0,
      'priority': notification.priority,
      'synced': 0,
    });
  }

  Future<List<NotificationModel>> getNotifications(String userId, {int? limit}) async {
    final db = await database;
    final maps = await db.query(
      'notifications',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
      limit: limit,
    );

    return maps.map((map) => NotificationModel.fromJson({
      'id': map['id'],
      'userId': map['user_id'],
      'appName': map['app_name'],
      'category': map['category'],
      'title': map['title'],
      'body': map['body'],
      'timestamp': map['timestamp'],
      'isFiltered': map['is_filtered'] == 1,
      'priority': map['priority'],
    })).toList();
  }

  // ===== Focus Session Operations =====

  Future<int> insertFocusSession(FocusSessionModel session) async {
    final db = await database;
    return await db.insert('focus_sessions', {
      'id': session.id,
      'user_id': session.userId,
      'start_time': session.startTime.toIso8601String(),
      'end_time': session.endTime?.toIso8601String(),
      'planned_duration': session.plannedDuration,
      'actual_duration': session.actualDuration,
      'is_active': session.isActive ? 1 : 0,
      'interruption_count': session.interruptionCount,
      'notes': session.notes,
      'synced': 0,
    });
  }

  Future<int> updateFocusSession(FocusSessionModel session) async {
    final db = await database;
    return await db.update(
      'focus_sessions',
      {
        'end_time': session.endTime?.toIso8601String(),
        'actual_duration': session.actualDuration,
        'is_active': session.isActive ? 1 : 0,
        'interruption_count': session.interruptionCount,
        'notes': session.notes,
      },
      where: 'id = ?',
      whereArgs: [session.id],
    );
  }

  Future<List<FocusSessionModel>> getFocusSessions(String userId, {int? limit}) async {
    final db = await database;
    final maps = await db.query(
      'focus_sessions',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'start_time DESC',
      limit: limit,
    );

    return maps.map((map) => FocusSessionModel.fromJson({
      'id': map['id'],
      'userId': map['user_id'],
      'startTime': map['start_time'],
      'endTime': map['end_time'],
      'plannedDuration': map['planned_duration'],
      'actualDuration': map['actual_duration'],
      'isActive': map['is_active'] == 1,
      'interruptionCount': map['interruption_count'],
      'notes': map['notes'],
    })).toList();
  }

  // ===== Screen Time Operations =====

  Future<int> insertScreenTime(ScreenTimeModel screenTime) async {
    final db = await database;
    return await db.insert('screen_time', {
      'id': screenTime.id,
      'user_id': screenTime.userId,
      'date': screenTime.date.toIso8601String(),
      'total_minutes': screenTime.totalMinutes,
      'app_usage': screenTime.appUsage.toString(),
      'pickup_count': screenTime.pickupCount,
      'synced': 0,
    });
  }

  Future<List<ScreenTimeModel>> getScreenTime(String userId, DateTime startDate, DateTime endDate) async {
    final db = await database;
    final maps = await db.query(
      'screen_time',
      where: 'user_id = ? AND date BETWEEN ? AND ?',
      whereArgs: [
        userId,
        startDate.toIso8601String(),
        endDate.toIso8601String(),
      ],
      orderBy: 'date ASC',
    );

    return maps.map((map) => ScreenTimeModel.fromJson({
      'id': map['id'],
      'userId': map['user_id'],
      'date': map['date'],
      'totalMinutes': map['total_minutes'],
      'appUsage': {}, // Parse from string if needed
      'pickupCount': map['pickup_count'],
    })).toList();
  }

  // ===== Utility Operations =====

  Future<void> clearAllData() async {
    final db = await database;
    await db.delete('cognitive_loads');
    await db.delete('notifications');
    await db.delete('focus_sessions');
    await db.delete('screen_time');
  }

  Future<void> close() async {
    final db = await database;
    await db.close();
  }
}
