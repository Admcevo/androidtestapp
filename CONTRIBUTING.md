# 🤝 Contributing to Cognitive Load Coach

Thank you for your interest in contributing to Cognitive Load Coach! This document provides guidelines and instructions for contributing.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Commit Guidelines](#commit-guidelines)
- [Pull Request Process](#pull-request-process)
- [Testing](#testing)
- [Documentation](#documentation)

## 📜 Code of Conduct

### Our Pledge

We are committed to providing a welcoming and inclusive environment for all contributors.

### Expected Behavior

- Be respectful and considerate
- Welcome newcomers and help them get started
- Accept constructive criticism gracefully
- Focus on what is best for the community

### Unacceptable Behavior

- Harassment or discrimination of any kind
- Trolling or insulting comments
- Publishing others' private information
- Other conduct that could reasonably be considered inappropriate

## 🚀 Getting Started

### Prerequisites

1. Fork the repository
2. Clone your fork:
   ```bash
   git clone https://github.com/YOUR_USERNAME/cognitive-load-coach.git
   cd cognitive-load-coach
   ```
3. Add upstream remote:
   ```bash
   git remote add upstream https://github.com/ORIGINAL_OWNER/cognitive-load-coach.git
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```

### Development Setup

Follow the [SETUP_GUIDE.md](SETUP_GUIDE.md) for detailed setup instructions.

## 🔄 Development Workflow

### 1. Create a Branch

```bash
# Update your fork
git checkout main
git pull upstream main

# Create a feature branch
git checkout -b feature/your-feature-name
```

Branch naming conventions:
- `feature/` - New features
- `bugfix/` - Bug fixes
- `hotfix/` - Critical fixes
- `docs/` - Documentation updates
- `refactor/` - Code refactoring
- `test/` - Test additions or updates

### 2. Make Changes

- Write clean, readable code
- Follow the coding standards (see below)
- Add tests for new features
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run tests
flutter test

# Run the app
flutter run

# Check for issues
flutter analyze
```

### 4. Commit Your Changes

```bash
git add .
git commit -m "feat: add new feature"
```

See [Commit Guidelines](#commit-guidelines) below.

### 5. Push to Your Fork

```bash
git push origin feature/your-feature-name
```

### 6. Create Pull Request

- Go to the original repository
- Click "New Pull Request"
- Select your branch
- Fill in the PR template
- Submit for review

## 💻 Coding Standards

### Dart Style Guide

Follow the [Effective Dart](https://dart.dev/guides/language/effective-dart) guidelines.

### Code Formatting

```bash
# Format all Dart files
dart format .

# Check formatting
dart format --output=none --set-exit-if-changed .
```

### Linting

```bash
# Run linter
flutter analyze

# Fix auto-fixable issues
dart fix --apply
```

### File Organization

```dart
// 1. Imports (grouped and sorted)
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/config/theme_config.dart';
import '../../models/user_model.dart';
import '../widgets/custom_button.dart';

// 2. Class definition
class MyWidget extends StatelessWidget {
  // 3. Constants
  static const String routeName = '/my-widget';
  
  // 4. Fields
  final String title;
  final VoidCallback? onPressed;
  
  // 5. Constructor
  const MyWidget({
    super.key,
    required this.title,
    this.onPressed,
  });
  
  // 6. Methods
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  
  // 7. Private methods
  void _handleTap() {
    // Implementation
  }
}
```

### Naming Conventions

- **Classes**: `PascalCase` (e.g., `UserModel`, `DashboardScreen`)
- **Files**: `snake_case` (e.g., `user_model.dart`, `dashboard_screen.dart`)
- **Variables**: `camelCase` (e.g., `userName`, `isLoading`)
- **Constants**: `camelCase` (e.g., `maxRetries`, `defaultTimeout`)
- **Private members**: Prefix with `_` (e.g., `_privateMethod`, `_internalState`)

### Documentation

Add documentation comments for public APIs:

```dart
/// Authenticates a user with email and password.
///
/// Returns [AuthResult] containing the user data and token on success,
/// or an error message on failure.
///
/// Example:
/// ```dart
/// final result = await authService.login(
///   email: 'user@example.com',
///   password: 'password123',
/// );
/// ```
Future<AuthResult> login({
  required String email,
  required String password,
}) async {
  // Implementation
}
```

## 📝 Commit Guidelines

### Commit Message Format

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types

- **feat**: New feature
- **fix**: Bug fix
- **docs**: Documentation changes
- **style**: Code style changes (formatting, etc.)
- **refactor**: Code refactoring
- **test**: Adding or updating tests
- **chore**: Maintenance tasks

### Examples

```bash
feat(auth): add biometric authentication

Implement fingerprint and face recognition login options
for enhanced security.

Closes #123
```

```bash
fix(dashboard): resolve cognitive load calculation error

The cognitive load score was incorrectly calculated when
no data was available. Added null checks and default values.

Fixes #456
```

```bash
docs(readme): update installation instructions

Added steps for downloading and installing Poppins fonts.
```

### Scope

Optional, indicates the area of change:
- `auth` - Authentication
- `dashboard` - Dashboard screen
- `notifications` - Notification management
- `diet` - Digital diet features
- `profile` - Profile and settings
- `ui` - UI components
- `core` - Core functionality
- `db` - Database operations

## 🔀 Pull Request Process

### Before Submitting

- [ ] Code follows style guidelines
- [ ] Self-review completed
- [ ] Comments added for complex code
- [ ] Documentation updated
- [ ] Tests added/updated
- [ ] All tests pass
- [ ] No new warnings from analyzer

### PR Template

```markdown
## Description
Brief description of changes

## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Breaking change
- [ ] Documentation update

## Testing
How has this been tested?

## Screenshots (if applicable)
Add screenshots for UI changes

## Checklist
- [ ] Code follows style guidelines
- [ ] Self-reviewed
- [ ] Commented complex code
- [ ] Updated documentation
- [ ] Added tests
- [ ] Tests pass
- [ ] No new warnings
```

### Review Process

1. Automated checks run (linting, tests)
2. Code review by maintainers
3. Address feedback
4. Approval and merge

## 🧪 Testing

### Writing Tests

#### Unit Tests

```dart
// test/viewmodels/auth_viewmodel_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:cognitive_load_coach/viewmodels/auth_viewmodel.dart';

void main() {
  group('AuthViewModel', () {
    late AuthViewModel viewModel;
    
    setUp(() {
      viewModel = AuthViewModel();
    });
    
    test('initial state is not authenticated', () {
      expect(viewModel.isAuthenticated, false);
      expect(viewModel.currentUser, isNull);
    });
    
    test('login updates authentication state', () async {
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

#### Widget Tests

```dart
// test/widgets/custom_button_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:cognitive_load_coach/ui/widgets/custom_button.dart';

void main() {
  testWidgets('CustomButton displays text', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            onPressed: () {},
          ),
        ),
      ),
    );
    
    expect(find.text('Test Button'), findsOneWidget);
  });
  
  testWidgets('CustomButton shows loading indicator', 
    (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CustomButton(
            text: 'Test Button',
            isLoading: true,
          ),
        ),
      ),
    );
    
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
```

### Running Tests

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/viewmodels/auth_viewmodel_test.dart

# Run with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

## 📚 Documentation

### Code Documentation

- Add doc comments to all public APIs
- Explain complex algorithms
- Document assumptions and limitations
- Provide usage examples

### README Updates

Update README.md when:
- Adding new features
- Changing setup process
- Updating dependencies
- Modifying architecture

### Architecture Documentation

Update ARCHITECTURE.md when:
- Adding new layers or patterns
- Changing data flow
- Introducing new services
- Modifying state management

## 🐛 Reporting Bugs

### Before Reporting

1. Check existing issues
2. Verify it's reproducible
3. Test on latest version

### Bug Report Template

```markdown
**Describe the bug**
Clear description of the bug

**To Reproduce**
Steps to reproduce:
1. Go to '...'
2. Click on '...'
3. See error

**Expected behavior**
What should happen

**Screenshots**
If applicable

**Environment:**
- Device: [e.g. Pixel 6]
- OS: [e.g. Android 13]
- App Version: [e.g. 1.0.0]
- Flutter Version: [e.g. 3.16.0]

**Additional context**
Any other relevant information
```

## 💡 Feature Requests

### Feature Request Template

```markdown
**Is your feature request related to a problem?**
Clear description of the problem

**Describe the solution you'd like**
What you want to happen

**Describe alternatives you've considered**
Other solutions you've thought about

**Additional context**
Mockups, examples, etc.
```

## 🏆 Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

## 📞 Getting Help

- **Questions**: Open a discussion on GitHub
- **Issues**: Create an issue with detailed information
- **Chat**: Join our community chat (if available)

## 📄 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing to Cognitive Load Coach! 🎉
