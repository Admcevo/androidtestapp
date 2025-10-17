# 🏗️ Architecture Documentation

## Overview

Cognitive Load Coach follows **Clean Architecture** principles with clear separation of concerns across three main layers: **UI**, **Domain**, and **Data**.

## Architecture Layers

```
┌─────────────────────────────────────────────────────────┐
│                     UI Layer                            │
│  (Screens, Widgets, ViewModels)                        │
│                                                         │
│  - Handles user interactions                           │
│  - Displays data                                       │
│  - Manages UI state                                    │
└─────────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────────┐
│                   Domain Layer                          │
│  (Models, Business Logic)                              │
│                                                         │
│  - Core business entities                              │
│  - Business rules                                      │
│  - Platform-independent                                │
└─────────────────────────────────────────────────────────┘
                         ↕
┌─────────────────────────────────────────────────────────┐
│                    Data Layer                           │
│  (Services, Repositories, APIs)                        │
│                                                         │
│  - Data fetching                                       │
│  - Local storage                                       │
│  - Network requests                                    │
└─────────────────────────────────────────────────────────┘
```

## Directory Structure

```
lib/
├── main.dart                          # App entry point
│
├── core/                              # Core functionality
│   ├── config/
│   │   ├── app_config.dart           # App-wide constants
│   │   └── theme_config.dart         # Theme configuration
│   │
│   ├── routes/
│   │   └── app_router.dart           # Navigation setup
│   │
│   ├── services/                      # Business services
│   │   ├── auth_service.dart         # Authentication
│   │   ├── storage_service.dart      # Local storage
│   │   └── notification_service.dart # Notifications
│   │
│   └── database/
│       └── database_helper.dart      # SQLite operations
│
├── models/                            # Data models
│   ├── user_model.dart
│   ├── cognitive_load_model.dart
│   ├── notification_model.dart
│   ├── focus_session_model.dart
│   └── digital_diet_model.dart
│
├── viewmodels/                        # State management
│   ├── auth_viewmodel.dart
│   ├── theme_viewmodel.dart
│   ├── dashboard_viewmodel.dart
│   ├── notification_viewmodel.dart
│   └── digital_diet_viewmodel.dart
│
└── ui/                                # User interface
    ├── screens/                       # Full screens
    │   ├── splash_screen.dart
    │   ├── auth/
    │   │   ├── login_screen.dart
    │   │   └── register_screen.dart
    │   ├── dashboard/
    │   │   └── dashboard_screen.dart
    │   ├── notifications/
    │   │   └── notification_management_screen.dart
    │   ├── digital_diet/
    │   │   └── digital_diet_screen.dart
    │   └── profile/
    │       ├── profile_screen.dart
    │       └── settings_screen.dart
    │
    └── widgets/                       # Reusable components
        ├── custom_button.dart
        ├── custom_text_field.dart
        ├── cognitive_load_card.dart
        └── recommendation_card.dart
```

## State Management

### Provider Pattern

The app uses **Provider** for state management:

```dart
// In main.dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => AuthViewModel()),
    ChangeNotifierProvider(create: (_) => ThemeViewModel()),
    ChangeNotifierProvider(create: (_) => DashboardViewModel()),
    // ... other providers
  ],
  child: MyApp(),
)
```

### ViewModel Structure

Each ViewModel extends `ChangeNotifier`:

```dart
class DashboardViewModel extends ChangeNotifier {
  // Private state
  bool _isLoading = false;
  List<Data> _data = [];
  
  // Public getters
  bool get isLoading => _isLoading;
  List<Data> get data => _data;
  
  // Public methods
  Future<void> loadData() async {
    _isLoading = true;
    notifyListeners(); // Update UI
    
    // Fetch data
    _data = await fetchData();
    
    _isLoading = false;
    notifyListeners(); // Update UI
  }
}
```

### Consuming State in UI

```dart
Consumer<DashboardViewModel>(
  builder: (context, viewModel, child) {
    if (viewModel.isLoading) {
      return CircularProgressIndicator();
    }
    return ListView(children: viewModel.data);
  },
)
```

## Navigation

### GoRouter Setup

Declarative routing with `go_router`:

```dart
final router = GoRouter(
  initialLocation: '/splash',
  redirect: (context, state) async {
    // Authentication guard
    final isLoggedIn = await checkAuth();
    if (!isLoggedIn && state.location != '/login') {
      return '/login';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/splash', builder: (_, __) => SplashScreen()),
    GoRoute(path: '/login', builder: (_, __) => LoginScreen()),
    GoRoute(path: '/dashboard', builder: (_, __) => DashboardScreen()),
    // ... more routes
  ],
);
```

### Navigation Usage

```dart
// Navigate to a route
context.go('/dashboard');

// Navigate with parameters
context.go('/profile/${userId}');

// Go back
context.pop();
```

## Data Flow

### Authentication Flow

```
User Input (UI)
    ↓
AuthViewModel.login()
    ↓
AuthService.login()
    ↓
HTTP Request to API
    ↓
Store JWT Token (SecureStorage)
    ↓
Update ViewModel State
    ↓
UI Updates (Navigate to Dashboard)
```

### Data Persistence Flow

```
User Action
    ↓
ViewModel Method
    ↓
DatabaseHelper / StorageService
    ↓
SQLite / SharedPreferences
    ↓
Data Stored Locally
    ↓
Sync with API (Background)
```

## Services

### AuthService

Handles authentication operations:
- Login
- Register
- Logout
- Token refresh
- Authentication status check

```dart
class AuthService {
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    // Make API call
    // Store token
    // Return result
  }
}
```

### StorageService

Manages local data storage:
- Secure storage (tokens)
- SharedPreferences (settings)
- Generic key-value storage

```dart
class StorageService {
  Future<void> saveToken(String token) async {
    await _secureStorage.write(key: 'token', value: token);
  }
  
  Future<String?> getToken() async {
    return await _secureStorage.read(key: 'token');
  }
}
```

### NotificationService

Handles local notifications:
- Show notifications
- Schedule notifications
- Focus mode alerts
- Cognitive load warnings

```dart
class NotificationService {
  Future<void> showNotification({
    required String title,
    required String body,
  }) async {
    // Show notification
  }
}
```

### DatabaseHelper

SQLite database operations:
- CRUD operations for all models
- Query optimization with indexes
- Data synchronization tracking

```dart
class DatabaseHelper {
  Future<int> insertCognitiveLoad(CognitiveLoadModel load) async {
    final db = await database;
    return await db.insert('cognitive_loads', load.toJson());
  }
}
```

## Models

### Data Models

All models follow a consistent pattern:

```dart
class UserModel {
  final String id;
  final String email;
  final String name;
  
  UserModel({
    required this.id,
    required this.email,
    required this.name,
  });
  
  // JSON serialization
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      name: json['name'],
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
    };
  }
  
  // Copy with method for immutability
  UserModel copyWith({String? name}) {
    return UserModel(
      id: id,
      email: email,
      name: name ?? this.name,
    );
  }
}
```

## UI Components

### Screen Structure

```dart
class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    // Load initial data
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<DashboardViewModel>().loadData();
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dashboard')),
      body: Consumer<DashboardViewModel>(
        builder: (context, viewModel, _) {
          // Build UI based on viewModel state
        },
      ),
    );
  }
}
```

### Reusable Widgets

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  
  const CustomButton({
    required this.text,
    this.onPressed,
    this.isLoading = false,
  });
  
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      child: isLoading 
        ? CircularProgressIndicator()
        : Text(text),
    );
  }
}
```

## Error Handling

### ViewModel Error Handling

```dart
class DashboardViewModel extends ChangeNotifier {
  String? _errorMessage;
  
  String? get errorMessage => _errorMessage;
  
  Future<void> loadData() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();
      
      // Fetch data
      _data = await fetchData();
      
    } catch (e) {
      _errorMessage = 'Failed to load data: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
```

### UI Error Display

```dart
if (viewModel.errorMessage != null) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(viewModel.errorMessage!),
      backgroundColor: Colors.red,
    ),
  );
}
```

## Testing Strategy

### Unit Tests

Test ViewModels and Services:

```dart
void main() {
  group('AuthViewModel', () {
    test('login success updates user state', () async {
      final viewModel = AuthViewModel();
      await viewModel.login(
        email: 'test@example.com',
        password: 'password',
      );
      
      expect(viewModel.isAuthenticated, true);
      expect(viewModel.currentUser, isNotNull);
    });
  });
}
```

### Widget Tests

Test UI components:

```dart
void main() {
  testWidgets('Login screen shows email and password fields', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: LoginScreen()),
    );
    
    expect(find.byType(TextField), findsNWidgets(2));
    expect(find.text('Sign In'), findsOneWidget);
  });
}
```

## Performance Optimization

### Best Practices

1. **Lazy Loading**: Load data only when needed
2. **Pagination**: Implement pagination for large lists
3. **Caching**: Cache frequently accessed data
4. **Image Optimization**: Use cached network images
5. **Build Optimization**: Use `const` constructors where possible

### Memory Management

```dart
@override
void dispose() {
  _controller.dispose();
  _subscription.cancel();
  super.dispose();
}
```

## Security Considerations

1. **Token Storage**: JWT tokens in encrypted secure storage
2. **API Communication**: HTTPS only in production
3. **Input Validation**: Validate all user inputs
4. **SQL Injection**: Use parameterized queries
5. **Sensitive Data**: Never log sensitive information

## Future Enhancements

- [ ] Implement repository pattern for better data abstraction
- [ ] Add offline-first capabilities with sync
- [ ] Implement proper error logging service
- [ ] Add analytics tracking
- [ ] Implement automated testing
- [ ] Add CI/CD pipeline

---

This architecture provides a solid foundation for scalability, maintainability, and testability.
