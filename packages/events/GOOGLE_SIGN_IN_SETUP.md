# Google Sign-In Setup Guide

This guide will help you fix the **Error Code 10 (DEVELOPER_ERROR)** when signing in with Google for event validation.

## Error Code 10: DEVELOPER_ERROR

This error occurs when Google Sign-In is not properly configured. Common causes:

1. **SHA-1 fingerprint not added to Firebase/Google Cloud Console**
2. **OAuth client ID not configured correctly**
3. **Package name mismatch**
4. **Missing google-services.json file**

## Step-by-Step Setup

### 1. Get Your SHA-1 Fingerprint

#### For Debug Build:
```bash
cd android
./gradlew signingReport
```

Look for the SHA-1 fingerprint in the output under `Variant: debug`:
```
SHA1: XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX:XX
```

#### Alternative Method (macOS/Linux):
```bash
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

#### For Release Build:
```bash
keytool -list -v -keystore /path/to/your/keystore.jks -alias your-key-alias
```

### 2. Create/Configure Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or select existing one
3. Add your Android app:
   - Package name: `com.wheelseye.debug_hub.debug_hub` (or your app's package name)
   - App nickname: (optional)
   - Debug signing certificate SHA-1: (paste your SHA-1 from step 1)
4. Download `google-services.json`
5. Place it in `android/app/` directory

### 3. Configure Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Navigate to **APIs & Services** > **Credentials**
4. Click **Create Credentials** > **OAuth client ID**
5. Choose **Android** as application type
6. Enter:
   - Name: (e.g., "DebugHub Android Client")
   - Package name: Your app's package name
   - SHA-1 certificate fingerprint: (from step 1)
7. Click **Create**
8. **Enable Google Sheets API**:
   - Go to **APIs & Services** > **Library**
   - Search for "Google Sheets API"
   - Click **Enable**

### 4. Update Android Configuration

#### android/app/build.gradle

Make sure you have:

```gradle
dependencies {
    // ... other dependencies
    implementation 'com.google.android.gms:play-services-auth:20.7.0'
}
```

#### android/build.gradle

```gradle
buildscript {
    dependencies {
        // ... other dependencies
        classpath 'com.google.gms:google-services:4.4.0'
    }
}
```

#### android/app/build.gradle (at the bottom)

```gradle
apply plugin: 'com.google.gms.google-services'
```

### 5. Verify Package Name

Check that your package name matches in:
- `android/app/build.gradle` (applicationId)
- Firebase Console
- Google Cloud Console OAuth client

### 6. For iOS (if needed)

1. In Firebase Console, add iOS app with your bundle ID
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/` directory
4. In Google Cloud Console, create OAuth client for iOS
5. Update `ios/Runner/Info.plist`:

```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>Editor</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
        </array>
    </dict>
</array>
```

## Verification Steps

1. **Check google-services.json exists**:
   ```bash
   ls android/app/google-services.json
   ```

2. **Verify SHA-1 is added**:
   - Firebase Console > Project Settings > Your Android App
   - Check "SHA certificate fingerprints" section

3. **Verify OAuth client exists**:
   - Google Cloud Console > APIs & Services > Credentials
   - Should see Android OAuth 2.0 Client ID

4. **Test the app**:
   - Clean and rebuild:
     ```bash
     flutter clean
     flutter pub get
     cd android && ./gradlew clean && cd ..
     flutter run
     ```

## Common Issues & Solutions

### Issue: "SHA-1 fingerprint not found"
**Solution**: Make sure you added the SHA-1 to Firebase Console under your Android app settings.

### Issue: "Package name mismatch"
**Solution**: Verify package name in:
- `android/app/build.gradle` (applicationId)
- Firebase Console
- Google Cloud Console

### Issue: "google-services.json not found"
**Solution**: 
1. Download from Firebase Console
2. Place in `android/app/` directory
3. Rebuild the app

### Issue: "OAuth client not configured"
**Solution**: 
1. Create OAuth client in Google Cloud Console
2. Add SHA-1 fingerprint
3. Enable Google Sheets API

### Issue: "Still getting error after setup"
**Solution**:
1. Clean build: `flutter clean && cd android && ./gradlew clean`
2. Delete app from device/emulator
3. Rebuild and reinstall
4. Wait a few minutes for Google's servers to update

## Quick Checklist

- [ ] SHA-1 fingerprint obtained
- [ ] SHA-1 added to Firebase Console
- [ ] `google-services.json` downloaded and placed in `android/app/`
- [ ] OAuth client created in Google Cloud Console
- [ ] Google Sheets API enabled
- [ ] Package name matches everywhere
- [ ] App cleaned and rebuilt

## Getting Help

If you're still experiencing issues:

1. Check the error message in the app - it should now show more details
2. Check Firebase Console logs
3. Verify all steps above
4. Try signing out and signing in again
5. Check that you're using the correct Google account

## Additional Resources

- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [Firebase Setup Guide](https://firebase.google.com/docs/flutter/setup)
- [Google Sheets API Setup](https://developers.google.com/sheets/api/guides/authorizing)

---

**Note**: After making configuration changes, it may take a few minutes for Google's servers to update. If the error persists, wait 5-10 minutes and try again.

