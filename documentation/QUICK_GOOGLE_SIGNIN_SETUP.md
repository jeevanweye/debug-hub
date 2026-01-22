# Quick Google Sign-In Setup for DebugHub

## Your Current Configuration

- **Package Name**: `com.wheelseye.debug_hub.debug_hub`
- **SHA-1 Fingerprint**: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`

## Quick Setup Steps

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project** (or select existing)
3. Follow the setup wizard

### Step 2: Add Android App to Firebase

1. In Firebase Console, click **Add App** > **Android**
2. Enter:
   - **Android package name**: `com.wheelseye.debug_hub.debug_hub`
   - **App nickname** (optional): DebugHub
   - **Debug signing certificate SHA-1**: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`
3. Click **Register app**
4. **Download** `google-services.json`
5. **Place the file** in: `android/app/google-services.json`

### Step 3: Enable Google Sheets API

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Navigate to **APIs & Services** > **Library**
4. Search for **"Google Sheets API"**
5. Click **Enable**

### Step 4: Create OAuth Client ID

1. In Google Cloud Console, go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **OAuth client ID**
3. If prompted, configure OAuth consent screen first:
   - User Type: **External** (for testing)
   - App name: DebugHub
   - User support email: (your email)
   - Developer contact: (your email)
   - Click **Save and Continue** through the steps
4. Back to Credentials, click **Create Credentials** > **OAuth client ID**
5. Choose **Android** as application type
6. Enter:
   - **Name**: DebugHub Android Client
   - **Package name**: `com.wheelseye.debug_hub.debug_hub`
   - **SHA-1 certificate fingerprint**: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`
7. Click **Create**

### Step 5: Update Android Build Files

#### Check `android/build.gradle.kts`:

Make sure you have the Google Services plugin:

```kotlin
buildscript {
    dependencies {
        // ... other dependencies
        classpath("com.google.gms:google-services:4.4.0")
    }
}
```

#### Check `android/app/build.gradle.kts`:

Add at the bottom:

```kotlin
plugins {
    // ... existing plugins
    id("com.google.gms.google-services")
}
```

And in dependencies:

```kotlin
dependencies {
    // ... other dependencies
    implementation("com.google.android.gms:play-services-auth:20.7.0")
}
```

### Step 6: Verify Setup

1. **Check google-services.json exists**:
   ```bash
   ls -la android/app/google-services.json
   ```

2. **Clean and rebuild**:
   ```bash
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter pub get
   flutter run
   ```

## Verification Checklist

- [ ] Firebase project created
- [ ] Android app added to Firebase with correct package name
- [ ] SHA-1 fingerprint added: `CF:76:A0:C1:22:6F:35:0E:AA:97:31:17:24:76:DF:66:AB:5A:04:6A`
- [ ] `google-services.json` downloaded and placed in `android/app/`
- [ ] Google Sheets API enabled
- [ ] OAuth client ID created for Android
- [ ] Android build files updated
- [ ] App cleaned and rebuilt

## Still Getting Error?

1. **Wait 5-10 minutes** after making changes (Google's servers need time to update)
2. **Delete the app** from your device/emulator
3. **Clean build** again:
   ```bash
   flutter clean
   cd android && ./gradlew clean && cd ..
   flutter run
   ```
4. **Check Firebase Console**:
   - Project Settings > Your Android App
   - Verify SHA-1 is listed under "SHA certificate fingerprints"
5. **Check Google Cloud Console**:
   - APIs & Services > Credentials
   - Verify OAuth client exists with correct package name and SHA-1

## Need Help?

See the detailed guide: `packages/events/GOOGLE_SIGN_IN_SETUP.md`

