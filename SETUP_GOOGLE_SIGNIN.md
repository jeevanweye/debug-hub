# Google Sign-In Setup - Action Required

## Current Status

✅ **SHA-1 Fingerprint Found**: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`  
✅ **Package Name**: `com.wheelseye.debug_hub.debug_hub`  
✅ **Build Files Updated**: Google Services plugin configured  
❌ **Missing**: `google-services.json` file

## What You Need To Do Now

### 1. Create Firebase Project (5 minutes)

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Add Project"** or select existing project
3. Follow the setup wizard

### 2. Add Android App to Firebase

1. In Firebase project, click **"Add App"** > **Android**
2. Enter these **exact values**:
   ```
   Package name: com.wheelseye.debug_hub.debug_hub
   SHA-1: CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A
   ```
3. Click **"Register app"**
4. **Download** `google-services.json`
5. **Copy the file** to: `DebugHub/android/app/google-services.json`

### 3. Enable Google Sheets API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** > **Library**
4. Search **"Google Sheets API"**
5. Click **Enable**

### 4. Create OAuth Client

1. In Google Cloud Console, go to **APIs & Services** > **Credentials**
2. Click **"Create Credentials"** > **OAuth client ID**
3. If asked, configure OAuth consent screen:
   - User Type: **External**
   - App name: DebugHub
   - Your email for support/contact
   - Click through and **Save**
4. Back to Credentials, create **OAuth client ID**:
   - Application type: **Android**
   - Name: DebugHub Android
   - Package name: `com.wheelseye.debug_hub.debug_hub`
   - SHA-1: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`
5. Click **Create**

### 5. Test

```bash
# Clean build
flutter clean
cd android && ./gradlew clean && cd ..

# Verify google-services.json exists
ls -la android/app/google-services.json

# Rebuild and run
flutter pub get
flutter run
```

## Quick Checklist

- [ ] Firebase project created
- [ ] Android app added with package name: `com.wheelseye.debug_hub.debug_hub`
- [ ] SHA-1 added: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`
- [ ] `google-services.json` downloaded and placed in `android/app/`
- [ ] Google Sheets API enabled
- [ ] OAuth client ID created
- [ ] App cleaned and rebuilt

## Still Getting Error?

1. **Wait 5-10 minutes** after setup (Google needs time to sync)
2. **Delete app** from device/emulator
3. **Clean rebuild**:
   ```bash
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter run
   ```

## Files Updated

✅ `android/settings.gradle.kts` - Added Google Services plugin  
✅ `android/app/build.gradle.kts` - Applied plugin and added dependency

**You just need to add the `google-services.json` file!**

