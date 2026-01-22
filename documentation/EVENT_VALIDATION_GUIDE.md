# Event Validation with Google Sheets - User Guide

## 🎯 Overview

The Event Validation feature allows you to validate your app's analytics events against a Google Sheet that contains the expected event definitions. This helps ensure that your analytics implementation matches your tracking plan.

---

## 🚀 Quick Start

### 1. Access Event Validation

In the DebugHub UI:
1. Open the **Events** tab (bottom navigation)
2. Look for the **📊 Google Sheets icon** in the top action bar
3. Tap the icon to open the Event Validation Dashboard

---

## 📋 Setup Requirements

### 1. Configure Package Name

When initializing DebugHub, provide your app's package name:

```dart
import 'package:debug_hub/debug_hub.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await DebugHubManager.initialize(
    packageName: 'com.yourcompany.yourapp',  // ← Add this
    mainColor: Colors.blue,
  );
  
  runApp(DebugHubManager.wrap(MyApp()));
}
```

### 2. Set Up Google Sheets

You need two Google Sheets:

#### A. Master Sheet
Contains mappings of package names to their event sheets.

**Format**:
| Package Name | Sheet ID | Range |
|--------------|----------|-------|
| com.yourcompany.yourapp | 1abc...xyz | Sheet1!A2:Z |

**Example**:
```
Package Name: com.yourcompany.yourapp
Sheet ID: 1abcdefghijklmnopqrstuvwxyz123456789
Range: Events!A2:Z
```

#### B. Events Sheet
Contains your event definitions with multiple version tabs.

**Format** (each tab represents a version):
| Event Name | Event Action | Event Category | Screen Name | ... |
|------------|--------------|----------------|-------------|-----|
| button_click | click | engagement | home_screen | ... |
| page_view | view | navigation | product_detail | ... |

---

## 🔐 Google Authentication

### First Time Setup

1. **Tap the Google Sheets icon** in Events tab
2. **Sign in with Google** when prompted
3. **Grant permissions** to access your Google Sheets
4. The app will remember your authentication

### What Permissions Are Needed?

- **Read access** to your Google Sheets
- **Email address** to identify your account

---

## 📊 Using Event Validation

### Step 1: Open Dashboard

Tap the **📊 Google Sheets icon** in the Events tab.

### Step 2: Sign In (if needed)

If not already signed in, you'll see a "Sign in with Google" button.

### Step 3: Select Version

Once signed in, you'll see a dropdown with available versions (sheet tabs):
- Select the version you want to validate against
- Example: "v1.0.0", "v2.0.0", etc.

### Step 4: Validate

Tap the **"Validate Events"** button.

### Step 5: View Results

The results screen shows:

#### ✅ Correct Events (Green)
Events that match exactly with the sheet definition.

#### ⚠️ Incorrect Events (Orange)
Events that were found but have mismatches:
- Wrong event action
- Wrong event category
- Wrong screen name
- Missing or extra properties

#### ❌ Not Found Events (Red)
Events defined in the sheet but not found in your app logs.

---

## 📈 Understanding Results

### Statistics

At the top of results, you'll see:
- **Total Events**: Number of events in the sheet
- **Found**: Events found in your app
- **Correct**: Events that match exactly
- **Incorrect**: Events with mismatches
- **Not Found**: Events missing from your app

### Event Details

Tap any event to see:
- **Sheet Definition**: What's expected
- **App Implementation**: What was logged
- **Differences**: What doesn't match

### Filtering

Use the filter chips to show:
- **All**: All events
- **Correct**: Only matching events
- **Incorrect**: Only mismatched events
- **Not Found**: Only missing events

---

## 🔍 Common Issues

### Issue: "Failed to load master sheet"

**Solution**:
- Check your internet connection
- Verify you're signed in with Google
- Ensure the master sheet ID is correct
- Check sheet sharing permissions

### Issue: "Package not found in master sheet"

**Solution**:
- Verify your `packageName` in DebugHub config
- Check the master sheet has an entry for your package
- Ensure package name matches exactly (case-sensitive)

### Issue: "No versions found"

**Solution**:
- Check your events sheet has multiple tabs
- Each tab should be named (e.g., "v1.0.0", "v2.0.0")
- Verify sheet sharing permissions

### Issue: "All events show as 'Not Found'"

**Solution**:
- Ensure you've triggered events in your app
- Check the Events tab has logged events
- Verify event names match exactly (case-sensitive)
- Check you selected the correct version

---

## 💡 Best Practices

### 1. Regular Validation

- Validate events before each release
- Check after implementing new features
- Verify after refactoring analytics code

### 2. Version Management

- Create a new sheet tab for each app version
- Name tabs clearly (e.g., "v1.0.0", "v2.0.0")
- Keep old versions for historical reference

### 3. Sheet Organization

- Use consistent column names
- Document special cases (dynamic screens, etc.)
- Keep the master sheet up to date

### 4. Team Collaboration

- Share sheets with your team
- Use comments in sheets for clarification
- Document validation results

---

## 📝 Sheet Column Definitions

### Required Columns

| Column | Description | Example |
|--------|-------------|---------|
| Event Name | Unique event identifier | `button_click` |
| Event Action | Action performed | `click`, `view`, `submit` |
| Event Category | Event category | `engagement`, `navigation` |
| Screen Name | Where event occurs | `home_screen`, `profile` |

### Optional Columns

| Column | Description | Example |
|--------|-------------|---------|
| Event Label | Additional context | `submit_button` |
| User ID | User identifier | `user_123` |
| Session ID | Session identifier | `session_abc` |
| Properties | JSON properties | `{"button_id": "submit"}` |

### Special Values

- **Dynamic Screen**: Use `"dynamic"` or `"user's screen"` for screens that vary
- **Optional Fields**: Leave empty if not required

---

## 🔄 Workflow Example

### Scenario: New Feature Release

1. **Before Development**
   - Update Google Sheet with new events
   - Add new version tab (e.g., "v2.0.0")

2. **During Development**
   - Implement analytics events
   - Test in debug mode
   - Check Events tab for logged events

3. **Before Release**
   - Open Event Validation
   - Select new version (v2.0.0)
   - Validate events
   - Fix any mismatches

4. **After Validation**
   - All events should be ✅ Correct
   - No ❌ Not Found events
   - Fix any ⚠️ Incorrect events

5. **Release**
   - Confident that analytics is correct
   - Tracking plan matches implementation

---

## 🛠️ Troubleshooting

### Debug Mode

If validation isn't working:

1. **Check Events Tab**
   - Are events being logged?
   - Do event names match the sheet?

2. **Check Sheet Access**
   - Can you open the sheet in browser?
   - Is it shared with your Google account?

3. **Check Configuration**
   - Is `packageName` set correctly?
   - Is master sheet ID correct?

4. **Check Network**
   - Are you online?
   - Can you access Google services?

---

## 📞 Support

### Need Help?

1. Check the [Google Sheets Integration Guide](packages/events/GOOGLE_SHEETS_INTEGRATION.md)
2. Review the [Integration Example](packages/events/INTEGRATION_EXAMPLE.md)
3. Check the [Implementation Summary](packages/events/IMPLEMENTATION_SUMMARY.md)

### Common Questions

**Q: Can I use this in production?**
A: DebugHub only works in debug mode, so event validation is only available during development.

**Q: Do I need to set up Google Cloud Console?**
A: Yes, you need to enable Google Sheets API and configure OAuth. See the [Google Sheets Integration Guide](packages/events/GOOGLE_SHEETS_INTEGRATION.md).

**Q: Can multiple developers use the same sheets?**
A: Yes! Share the sheets with your team and everyone can validate events.

**Q: What if I don't want to use Google Sheets?**
A: The feature is optional. You can still use all other DebugHub features without it.

---

## ✨ Tips & Tricks

### Tip 1: Use Descriptive Version Names
Instead of "v1", "v2", use "v1.0.0_initial", "v2.0.0_new_feature"

### Tip 2: Document Special Cases
Use sheet comments to explain dynamic screens or complex validation rules

### Tip 3: Validate Frequently
Don't wait until release - validate during development

### Tip 4: Share Results
Use the share button to send validation results to your team

### Tip 5: Keep Sheets Updated
Update sheets before implementing new events

---

## 🎓 Summary

Event Validation helps you:
- ✅ Ensure analytics implementation is correct
- ✅ Catch mistakes before release
- ✅ Maintain consistency across versions
- ✅ Collaborate with your team
- ✅ Save time debugging analytics issues

**Access it with just one tap from the Events tab!** 📊

---

*For detailed technical documentation, see [GOOGLE_SHEETS_INTEGRATION.md](packages/events/GOOGLE_SHEETS_INTEGRATION.md)*

