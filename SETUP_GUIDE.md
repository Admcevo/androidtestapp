# 🚀 Setup Guide - Cognitive Load Coach

This guide will help you set up and run the Cognitive Load Coach application.

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

1. **Flutter SDK** (version 3.0 or higher)
   - Download from: https://flutter.dev/docs/get-started/install
   - Verify installation: `flutter --version`

2. **Android Studio** or **VS Code**
   - Android Studio: https://developer.android.com/studio
   - VS Code: https://code.visualstudio.com/

3. **Android SDK** (API level 24+)
   - Install via Android Studio SDK Manager
   - Set up Android emulator or connect physical device

4. **Git**
   - Download from: https://git-scm.com/downloads

## 🔧 Step-by-Step Setup

### 1. Clone the Repository

```bash
git clone <repository-url>
cd testapp
```

### 2. Install Flutter Dependencies

```bash
flutter pub get
```

This will download all required packages specified in `pubspec.yaml`.

### 3. Download and Install Fonts

The app uses the **Poppins** font family. You need to download it manually:

1. Visit [Google Fonts - Poppins](https://fonts.google.com/specimen/Poppins)
2. Click "Download family"
3. Extract the ZIP file
4. Copy the following files to `assets/fonts/`:
   - `Poppins-Regular.ttf`
   - `Poppins-Medium.ttf`
   - `Poppins-SemiBold.ttf`
   - `Poppins-Bold.ttf`

### 4. Configure API Endpoint (Optional)

If you have a backend API server:

1. Open `lib/core/config/app_config.dart`
2. Update the `baseUrl` variable:
   ```dart
   static String baseUrl = 'https://your-api-url.com/api';
   ```

**Note**: You can also change this later from the app's Settings screen.

### 5. Set Up Android Device/Emulator

#### Option A: Using Android Emulator
```bash
# List available emulators
flutter emulators

# Launch an emulator
flutter emulators --launch <emulator_id>
```

#### Option B: Using Physical Device
1. Enable Developer Options on your Android device
2. Enable USB Debugging
3. Connect device via USB
4. Verify connection: `flutter devices`

### 6. Run the Application

```bash
# Run in debug mode
flutter run

# Run in release mode
flutter run --release

# Run on specific device
flutter run -d <device_id>
```

## 🏗️ Building the App

### Build APK (for testing)

```bash
flutter build apk --release
```

The APK will be located at: `build/app/outputs/flutter-apk/app-release.apk`

### Build App Bundle (for Play Store)

```bash
flutter build appbundle --release
```

The bundle will be located at: `build/app/outputs/bundle/release/app-release.aab`

## 🔑 Setting Up Backend API (Optional)

If you want to use the authentication features with a real backend:

### Required Endpoints

Your backend should implement these endpoints:

#### 1. Login
```
POST /api/auth/login
Content-Type: application/json

Request Body:
{
  "email": "user@example.com",
  "password": "password123"
}

Response (200 OK):
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "user": {
    "id": "user_id",
    "email": "user@example.com",
    "name": "John Doe",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### 2. Register
```
POST /api/auth/register
Content-Type: application/json

Request Body:
{
  "email": "newuser@example.com",
  "password": "password123",
  "name": "Jane Doe"
}

Response (201 Created):
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "refreshToken": "refresh_token_here",
  "user": {
    "id": "user_id",
    "email": "newuser@example.com",
    "name": "Jane Doe",
    "createdAt": "2024-01-01T00:00:00.000Z"
  }
}
```

#### 3. Refresh Token
```
POST /api/auth/refresh
Content-Type: application/json

Request Body:
{
  "refreshToken": "refresh_token_here"
}

Response (200 OK):
{
  "token": "new_jwt_token_here"
}
```

### Simple Node.js Backend Example

Create a simple Express.js server for testing:

```javascript
const express = require('express');
const jwt = require('jsonwebtoken');
const app = express();

app.use(express.json());

const SECRET_KEY = 'your-secret-key';
const users = []; // In-memory storage (use database in production)

// Login
app.post('/api/auth/login', (req, res) => {
  const { email, password } = req.body;
  
  const user = users.find(u => u.email === email && u.password === password);
  
  if (!user) {
    return res.status(401).json({ message: 'Invalid credentials' });
  }
  
  const token = jwt.sign({ userId: user.id }, SECRET_KEY, { expiresIn: '7d' });
  
  res.json({
    token,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt
    }
  });
});

// Register
app.post('/api/auth/register', (req, res) => {
  const { email, password, name } = req.body;
  
  if (users.find(u => u.email === email)) {
    return res.status(400).json({ message: 'User already exists' });
  }
  
  const user = {
    id: Date.now().toString(),
    email,
    password, // Hash this in production!
    name,
    createdAt: new Date().toISOString()
  };
  
  users.push(user);
  
  const token = jwt.sign({ userId: user.id }, SECRET_KEY, { expiresIn: '7d' });
  
  res.status(201).json({
    token,
    user: {
      id: user.id,
      email: user.email,
      name: user.name,
      createdAt: user.createdAt
    }
  });
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});
```

## 🧪 Testing Without Backend

The app includes mock data for testing without a backend:

1. Run the app normally
2. Use any email/password combination on the login screen
3. The app will simulate authentication (won't actually validate)
4. All data will be stored locally in SQLite

## 🐛 Troubleshooting

### Issue: "Flutter command not found"
**Solution**: Add Flutter to your PATH environment variable.

### Issue: "No devices found"
**Solution**: 
- Ensure Android emulator is running
- Or connect physical device with USB debugging enabled
- Run `flutter doctor` to diagnose issues

### Issue: "Gradle build failed"
**Solution**:
- Clean the project: `flutter clean`
- Get dependencies: `flutter pub get`
- Rebuild: `flutter run`

### Issue: "Font not found"
**Solution**: 
- Ensure Poppins font files are in `assets/fonts/`
- Run `flutter pub get` after adding fonts
- Restart the app

### Issue: "Network error" when logging in
**Solution**:
- Check API endpoint in Settings
- Ensure backend server is running
- Check device/emulator has internet access
- For localhost, use `10.0.2.2` instead of `localhost` on Android emulator

### Issue: "Permission denied" errors
**Solution**:
- Grant necessary permissions from device Settings
- For usage stats, manually enable in Settings > Apps > Special access > Usage access

## 📱 First Run

When you first run the app:

1. **Splash Screen** will appear for 3 seconds
2. You'll be redirected to the **Login Screen**
3. Click "Sign Up" to create an account
4. Fill in your details and register
5. You'll be automatically logged in and see the **Dashboard**

## 🎨 Customization

### Changing Theme Colors

Edit `lib/core/config/theme_config.dart`:

```dart
static const Color primaryPurple = Color(0xFF6A0DAD); // Change this
static const Color lightPurple = Color(0xFFA020F0);   // And this
```

### Changing App Name

1. Edit `lib/core/config/app_config.dart`:
   ```dart
   static const String appName = 'Your App Name';
   ```

2. Edit `android/app/src/main/AndroidManifest.xml`:
   ```xml
   android:label="Your App Name"
   ```

### Adding New Features

Follow the Clean Architecture pattern:
1. Create model in `lib/models/`
2. Create service in `lib/core/services/`
3. Create viewmodel in `lib/viewmodels/`
4. Create UI in `lib/ui/screens/`

## 📚 Additional Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Provider Package](https://pub.dev/packages/provider)
- [GoRouter Package](https://pub.dev/packages/go_router)
- [Material Design Guidelines](https://material.io/design)

## 💡 Tips

1. **Hot Reload**: Press `r` in terminal while app is running to hot reload changes
2. **Hot Restart**: Press `R` for full restart
3. **DevTools**: Run `flutter pub global activate devtools` then `flutter pub global run devtools` for debugging tools
4. **Performance**: Use `flutter run --profile` to test performance
5. **Logs**: Use `flutter logs` to view detailed logs

## 🆘 Getting Help

If you encounter issues:

1. Check this guide's Troubleshooting section
2. Run `flutter doctor -v` and fix any issues
3. Check the main README.md for more information
4. Open an issue on GitHub with:
   - Flutter version (`flutter --version`)
   - Error message
   - Steps to reproduce

---

Happy coding! 🚀
