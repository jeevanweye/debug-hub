# Google Sign-In Setup (Updated)

## Important: No google-services.json Required!

Unlike Firebase projects, **Google Sign-In and Google Sheets API don't require `google-services.json`**. The `android_logger` project works the same way - it uses Google APIs directly without Firebase.

## What You Still Need

### 1. Create OAuth Client in Google Cloud Console

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project (or use existing)
3. **Enable Google Sheets API**:
   - APIs & Services > Library
   - Search "Google Sheets API" > Enable
4. **Create OAuth Client ID**:
   - APIs & Services > Credentials
   - Create Credentials > OAuth client ID
   - Configure OAuth consent screen first (if prompted):
     - User Type: External
     - App name: DebugHub
     - Your email
   - Create OAuth client:
     - Application type: **Android**
     - Name: DebugHub Android
     - Package name: `com.wheelseye.debug_hub.debug_hub`
     - SHA-1: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`

### 2. That's It!

No `google-services.json` file needed. The app should build and run now.

## Verification

```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

## Current Configuration

✅ **Package Name**: `com.wheelseye.debug_hub.debug_hub`  
✅ **SHA-1**: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`  
✅ **Google Services Plugin**: Removed (not needed)  
✅ **Dependencies**: `play-services-auth` added

## Still Getting Error Code 10?

1. **Verify OAuth Client**:
   - Google Cloud Console > Credentials
   - Check OAuth client exists with correct package name and SHA-1
   
2. **Wait 5-10 minutes** after creating OAuth client (Google needs time to sync)

3. **Delete app** from device/emulator and reinstall

4. **Check package name matches**:
   - `android/app/build.gradle.kts` (applicationId)
   - Google Cloud Console OAuth client

## Difference from Firebase Setup

- ❌ **No Firebase project needed**
- ❌ **No google-services.json needed**
- ✅ **Just Google Cloud Console OAuth client**
- ✅ **Just enable Google Sheets API**

This matches how `android_logger` is configured - it uses Google APIs directly without Firebase.

