# Google Sign-In Setup Guide for DebugHub

**Complete setup guide for Google Sign-In integration on iOS and Android platforms**

---

## 📋 Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Android Setup](#android-setup)
- [iOS Setup](#ios-setup)
- [Testing & Verification](#testing--verification)
- [Troubleshooting](#troubleshooting)
- [Best Practices](#best-practices)

---

## Overview

This guide explains how to configure Google Sign-In for the DebugHub event validation feature. Google Sign-In is required to access Google Sheets API for validating analytics events against your configuration spreadsheet.

### What You'll Need

- Google Cloud Console access
- Firebase Console access (recommended)
- Android Studio (for Android)
- Xcode (for iOS)
- Your app's package name / bundle ID

---

## Prerequisites

### 1. Create Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click **Select a project** > **New Project**
3. Enter project name (e.g., "DebugHub")
4. Click **Create**
5. Wait for project creation to complete

### 2. Enable Required APIs

1. In Google Cloud Console, select your project
2. Navigate to **APIs & Services** > **Library**
3. Search and enable the following APIs:
   - **Google Sign-In API**
   - **Google Sheets API**
   - **Google Drive API** (optional, for better sheets access)

### 3. Configure OAuth Consent Screen

1. Go to **APIs & Services** > **OAuth consent screen**
2. Choose **External** user type (for testing)
3. Fill in required information:
   - **App name**: DebugHub (or your app name)
   - **User support email**: Your email
   - **Developer contact**: Your email
4. Click **Save and Continue**
5. Skip **Scopes** (click Save and Continue)
6. Add test users (optional, for testing)
7. Click **Save and Continue**
8. Review and click **Back to Dashboard**

---

## Android Setup

### Step 1: Get Your SHA-1 Certificate Fingerprint

The SHA-1 fingerprint is required to authenticate your app with Google services.

#### For Debug Build (Development)

Open terminal and run:

```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### For Release Build (Production)

```bash
keytool -list -v -keystore /path/to/your/release.keystore -alias your-key-alias
```

**Example Output:**
```
Certificate fingerprints:
     SHA1: CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A
     SHA256: ...
```

**Copy the SHA-1 fingerprint** - you'll need it in the next steps.

> **Note**: On Windows, replace `~/.android/debug.keystore` with `%USERPROFILE%\.android\debug.keystore`

### Step 2: Create Firebase Project (Recommended)

Using Firebase simplifies the setup process.

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add project**
3. Select your existing Google Cloud project (or create new)
4. Enable Google Analytics (optional)
5. Click **Create project**

### Step 3: Add Android App to Firebase

1. In Firebase Console, click **Add app** > **Android**
2. Enter your app details:
   - **Android package name**: `com.yourcompany.yourapp` (from `android/app/build.gradle.kts`)
   - **App nickname** (optional): DebugHub
   - **Debug signing certificate SHA-1**: Paste your SHA-1 from Step 1
3. Click **Register app**
4. **Download `google-services.json`**
5. Click **Next** through the remaining steps

### Step 4: Add google-services.json to Your Project

1. Place the downloaded `google-services.json` file in:
   ```
   android/app/google-services.json
   ```

2. Verify the file structure:
   ```
   your_flutter_project/
   ├── android/
   │   ├── app/
   │   │   ├── google-services.json  ← Place here
   │   │   └── build.gradle.kts
   │   └── build.gradle.kts
   ```

### Step 5: Update Android Build Configuration

#### Update `android/build.gradle.kts`:

Add the Google Services plugin to buildscript dependencies:

```kotlin
buildscript {
    repositories {
        google()
        mavenCentral()
    }
    dependencies {
        classpath("com.android.tools.build:gradle:8.1.0")
        classpath("org.jetbrains.kotlin:kotlin-gradle-plugin:1.9.0")
        // Add this line
        classpath("com.google.gms:google-services:4.4.0")
    }
}

allprojects {
    repositories {
        google()
        mavenCentral()
    }
}
```

#### Update `android/app/build.gradle.kts`:

Add the plugin at the top:

```kotlin
plugins {
    id("com.android.application")
    id("kotlin-android")
    id("dev.flutter.flutter-gradle-plugin")
    // Add this line
    id("com.google.gms.google-services")
}

android {
    namespace = "com.yourcompany.yourapp"
    compileSdk = 34
    
    defaultConfig {
        applicationId = "com.yourcompany.yourapp"
        minSdk = 21
        targetSdk = 34
        versionCode = 1
        versionName = "1.0.0"
    }
    
    // ... rest of configuration
}

dependencies {
    // Add Google Play Services Auth
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}

flutter {
    source = "../.."
}
```

### Step 6: Create OAuth Client ID for Android

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your project
3. Navigate to **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. Select **Android** as application type
6. Fill in the form:
   - **Name**: DebugHub Android Client
   - **Package name**: `com.yourcompany.yourapp` (must match your app)
   - **SHA-1 certificate fingerprint**: Paste your SHA-1 from Step 1
7. Click **Create**

> **Important**: Create separate OAuth clients for debug and release builds if they have different SHA-1 fingerprints.
---

## iOS Setup

### Step 1: Add iOS App to Firebase

1. In Firebase Console, click **Add app** > **iOS**
2. Enter your app details:
   - **iOS bundle ID**: `com.yourcompany.yourapp` (from `ios/Runner/Info.plist`)
   - **App nickname** (optional): DebugHub
   - **App Store ID** (optional): Leave blank for now
3. Click **Register app**
4. **Download `GoogleService-Info.plist`**
5. Click **Next** through the remaining steps

### Step 2: Add GoogleService-Info.plist to Your Project

#### Using Xcode (Recommended):

1. Open your iOS project in Xcode:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. Right-click on **Runner** folder in the project navigator
3. Select **Add Files to "Runner"...**
4. Select the downloaded `GoogleService-Info.plist`
5. **Important**: Check **"Copy items if needed"**
6. **Important**: Make sure **"Runner" target is selected**
7. Click **Add**

#### Manual Method:

1. Place `GoogleService-Info.plist` in:
   ```
   ios/Runner/GoogleService-Info.plist
   ```

2. Verify the file structure:
   ```
   your_flutter_project/
   ├── ios/
   │   ├── Runner/
   │   │   ├── GoogleService-Info.plist  ← Place here
   │   │   ├── Info.plist
   │   │   └── AppDelegate.swift
   ```

### Step 3: Create OAuth Client ID for iOS

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Navigate to **APIs & Services** > **Credentials**
3. Click **Create Credentials** > **OAuth client ID**
4. Select **iOS** as application type
5. Fill in the form:
   - **Name**: DebugHub iOS Client
   - **Bundle ID**: `com.yourcompany.yourapp` (must match your app)
6. Click **Create**
7. **Copy the iOS Client ID** (format: `xxxxx.apps.googleusercontent.com`)

### Step 4: Configure URL Schemes

Update `ios/Runner/Info.plist` to add URL schemes:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <!-- Existing keys... -->
    
    <!-- Add Google Sign-In URL Scheme -->
    <key>CFBundleURLTypes</key>
    <array>
        <dict>
            <key>CFBundleTypeRole</key>
            <string>Editor</string>
            <key>CFBundleURLSchemes</key>
            <array>
                <!-- Replace with your REVERSED_CLIENT_ID from GoogleService-Info.plist -->
                <string>REVERSED_CLIENT_ID</string>
            </array>
        </dict>
    </array>
    
    
    <!-- Existing keys... -->
</dict>
</plist>
```

**To find your REVERSED_CLIENT_ID:**

1. Open `GoogleService-Info.plist`
2. Look for the key `REVERSED_CLIENT_ID`
3. Copy its value (format: `com.googleusercontent.apps.xxxxx`)
4. Use this value in the URL scheme above

**Example:**

If your `REVERSED_CLIENT_ID` is `com.googleusercontent.apps.123456789-abcdefg`, then:

```xml
<key>CFBundleURLSchemes</key>
<array>
    <string>com.googleusercontent.apps.123456789-abcdefg</string>
</array>
```

### Step 5: Update Podfile (if needed)

Open `ios/Podfile` and ensure minimum iOS version is 12.0 or higher:

```ruby
platform :ios, '12.0'

# ... rest of Podfile
```

### Step 6: Install CocoaPods Dependencies

```bash
cd ios
pod install
cd ..
```

---

## Testing & Verification

### Android Testing

1. **Clean and rebuild**:
   ```bash
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run
   ```

3. **Test Google Sign-In**:
   - Open DebugHub
   - Navigate to Events tab
   - Tap on Event Validation
   - Tap "Sign in with Google"
   - Select your Google account
   - Grant permissions

4. **Verify in logs**:
   ```bash
   flutter logs
   ```
   Look for successful sign-in messages.

### iOS Testing

1. **Clean and rebuild**:
   ```bash
   flutter clean
   cd ios && pod install && cd ..
   flutter pub get
   ```

2. **Run the app**:
   ```bash
   flutter run -d ios
   ```

3. **Test Google Sign-In**:
   - Open DebugHub
   - Navigate to Events tab
   - Tap on Event Validation
   - Tap "Sign in with Google"
   - Select your Google account
   - Grant permissions

4. **Verify in Xcode console**:
   - Open Xcode
   - Window > Devices and Simulators
   - Select your device
   - View device logs

### Common Test Scenarios

#### Test 1: Basic Sign-In
```dart
// In your Flutter code
final GoogleSignIn _googleSignIn = GoogleSignIn(
  scopes: ['email', 'https://www.googleapis.com/auth/spreadsheets.readonly'],
);

Future<void> testSignIn() async {
  try {
    final account = await _googleSignIn.signIn();
    print('Signed in: ${account?.email}');
  } catch (error) {
    print('Sign in error: $error');
  }
}
```

#### Test 2: Access Google Sheets
```dart
Future<void> testSheetsAccess() async {
  try {
    final account = await _googleSignIn.signIn();
    final authHeaders = await account?.authHeaders;
    
    // Use authHeaders to access Google Sheets API
    print('Auth headers: $authHeaders');
  } catch (error) {
    print('Sheets access error: $error');
  }
}
```

---

## Troubleshooting

### Android Issues

#### Error: "Sign in failed with error code 10"

**Cause**: SHA-1 fingerprint mismatch or not configured properly.

**Solutions**:

1. **Verify SHA-1 fingerprint**:
   ```bash
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

2. **Check Firebase Console**:
   - Go to Project Settings > Your Android App
   - Verify SHA-1 is listed under "SHA certificate fingerprints"
   - If not, click "Add fingerprint" and add your SHA-1

3. **Check Google Cloud Console**:
   - APIs & Services > Credentials
   - Verify OAuth client exists with correct package name and SHA-1
   - If not, create a new one

4. **Wait and retry**:
   - Google's servers need 5-10 minutes to propagate changes
   - Delete app from device and reinstall
   - Clean build: `flutter clean && flutter run`

#### Error: "google-services.json not found"

**Solution**:
1. Verify file location: `android/app/google-services.json`
2. Check file is not in `.gitignore`
3. Rebuild project: `flutter clean && flutter run`

#### Error: "Default FirebaseApp is not initialized"

**Solution**:
1. Ensure `google-services.json` is in correct location
2. Verify Google Services plugin is applied in `android/app/build.gradle.kts`:
   ```kotlin
   plugins {
       id("com.google.gms.google-services")
   }
   ```
3. Clean and rebuild

### iOS Issues

#### Error: "Sign in failed with error code -5"

**Cause**: URL scheme not configured or incorrect.

**Solutions**:

1. **Verify URL scheme in Info.plist**:
   - Open `ios/Runner/Info.plist`
   - Check `CFBundleURLSchemes` contains your `REVERSED_CLIENT_ID`

2. **Get REVERSED_CLIENT_ID from GoogleService-Info.plist**:
   - Open `GoogleService-Info.plist`
   - Copy value of `REVERSED_CLIENT_ID` key
   - Add to Info.plist URL schemes

3. **Example**:
   ```xml
   <key>CFBundleURLSchemes</key>
   <array>
       <string>com.googleusercontent.apps.123456789-abcdefg</string>
   </array>
   ```

#### Error: "GoogleService-Info.plist not found"

**Solution**:
1. Verify file is added to Xcode project (not just copied to folder)
2. In Xcode, check "Runner" target includes the file
3. Re-add file using Xcode: Right-click Runner > Add Files to "Runner"

#### Error: "The operation couldn't be completed"

**Solution**:
1. Check bundle ID matches in:
   - `ios/Runner/Info.plist`
   - Firebase Console
   - Google Cloud Console OAuth client
2. Verify `GIDClientID` in Info.plist matches your iOS Client ID
3. Clean build folder in Xcode: Product > Clean Build Folder

### General Issues

#### Error: "API not enabled"

**Solution**:
1. Go to Google Cloud Console
2. APIs & Services > Library
3. Enable:
   - Google Sign-In API
   - Google Sheets API
4. Wait 5 minutes for changes to propagate

#### Error: "Access blocked: This app's request is invalid"

**Solution**:
1. Check OAuth consent screen is configured
2. Add your email as a test user
3. Verify app is in "Testing" mode (not "Production")
4. Check scopes are correctly configured

#### Error: "Network error" or "Timeout"

**Solution**:
1. Check internet connection
2. Verify device/emulator can access Google services
3. Try on a different network
4. Check firewall settings

---

## Best Practices

### Security

1. **Never commit credentials**:
   ```gitignore
   # .gitignore
   android/app/google-services.json
   ios/Runner/GoogleService-Info.plist
   ```

2. **Use different configurations for debug/release**:
   - Separate Firebase projects for development and production
   - Different OAuth clients for debug and release builds
   - Different SHA-1 fingerprints for debug and release keystores

3. **Restrict API keys**:
   - In Google Cloud Console, restrict API keys to your app
   - Set application restrictions (Android/iOS)
   - Set API restrictions (only allow required APIs)

### Development

1. **Use debug keystore during development**:
   - Consistent SHA-1 across team members
   - Easier to share configuration

2. **Document your setup**:
   - Keep track of package names, bundle IDs
   - Document SHA-1 fingerprints used
   - Save OAuth client IDs

3. **Test on real devices**:
   - Emulators may have issues with Google Play Services
   - Test on both Android and iOS devices

### Production

1. **Generate release keystore**:
   ```bash
   keytool -genkey -v -keystore ~/release.keystore -alias release -keyalg RSA -keysize 2048 -validity 10000
   ```

2. **Get release SHA-1**:
   ```bash
   keytool -list -v -keystore ~/release.keystore -alias release
   ```

3. **Add release SHA-1 to Firebase and Google Cloud Console**

4. **Create separate OAuth client for release build**

5. **Test release build before publishing**:
   ```bash
   flutter build apk --release
   flutter build ios --release
   ```

### Environment-Specific Configuration

Use Flutter flavors to manage different environments:

```dart
// lib/config/google_signin_config.dart
class GoogleSignInConfig {
  static String getClientId() {
    const flavor = String.fromEnvironment('FLAVOR', defaultValue: 'dev');
    
    switch (flavor) {
      case 'prod':
        return 'YOUR_PROD_CLIENT_ID.apps.googleusercontent.com';
      case 'staging':
        return 'YOUR_STAGING_CLIENT_ID.apps.googleusercontent.com';
      default:
        return 'YOUR_DEV_CLIENT_ID.apps.googleusercontent.com';
    }
  }
}
```

---

## Quick Reference

### Android Checklist

- [ ] SHA-1 fingerprint generated
- [ ] Firebase project created
- [ ] Android app added to Firebase with SHA-1
- [ ] `google-services.json` downloaded and placed in `android/app/`
- [ ] Google Services plugin added to `build.gradle.kts`
- [ ] Google Play Services Auth dependency added
- [ ] OAuth client ID created for Android
- [ ] Web client ID created
- [ ] Google Sheets API enabled
- [ ] App tested on device

### iOS Checklist

- [ ] Firebase project created
- [ ] iOS app added to Firebase
- [ ] `GoogleService-Info.plist` downloaded
- [ ] `GoogleService-Info.plist` added to Xcode project
- [ ] URL scheme configured in Info.plist
- [ ] `GIDClientID` added to Info.plist
- [ ] OAuth client ID created for iOS
- [ ] CocoaPods dependencies installed
- [ ] Google Sheets API enabled
- [ ] App tested on device

### Required Files

**Android**:
- `android/app/google-services.json`
- `android/build.gradle.kts` (with Google Services plugin)
- `android/app/build.gradle.kts` (with plugin and dependencies)

**iOS**:
- `ios/Runner/GoogleService-Info.plist`
- `ios/Runner/Info.plist` (with URL schemes and GIDClientID)
- `ios/Podfile` (with minimum iOS version)

---

## Additional Resources

### Official Documentation

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Console](https://console.firebase.google.com/)
- [Google Cloud Console](https://console.cloud.google.com/)
- [Google Sheets API](https://developers.google.com/sheets/api)

### Useful Commands

```bash
# Get SHA-1 (Android Debug)
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Get SHA-1 (Android Release)
keytool -list -v -keystore /path/to/release.keystore -alias your-alias

# Clean Flutter project
flutter clean

# Clean Android build
cd android && ./gradlew clean && cd ..

# Install iOS pods
cd ios && pod install && cd ..

# Run Flutter app
flutter run

# Build release APK
flutter build apk --release

# Build release iOS
flutter build ios --release
```

---

## Support

If you encounter issues not covered in this guide:

1. Check [DebugHub GitHub Issues](https://github.com/yourusername/DebugHub/issues)
2. Review [Google Sign-In Flutter plugin issues](https://github.com/flutter/plugins/issues)
3. Check [Stack Overflow](https://stackoverflow.com/questions/tagged/google-signin+flutter)
4. Open a new issue with:
   - Platform (Android/iOS)
   - Error message
   - Steps to reproduce
   - Configuration details (without sensitive data)

---

**Last Updated**: January 2024  
**DebugHub Version**: 1.0.0  
**Google Sign-In Plugin Version**: 6.2.1+

---

<p align="center">
  <strong>Happy Debugging! 🐛✨</strong>
</p>
