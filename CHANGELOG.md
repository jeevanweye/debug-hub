# Changelog

All notable changes to the DebugHub project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [1.0.0] - 2024-01-22

### 🎉 Initial Release

The first stable release of DebugHub - A comprehensive Flutter debugging and monitoring toolkit built with Clean Architecture and SOLID Principles.

### ✨ Features Added

#### Core Functionality
- **DebugHub Manager** - Simplified API for easy integration
- **3-Line Integration** - Minimal setup required to get started
- **Floating Bubble UI** - Always accessible debug interface
- **Bottom Navigation** - Easy tab switching between features
- **Production Safety** - Auto-disables in release builds

#### Network Monitoring
- **HTTP/HTTPS Request Capture** - Automatic capture of all network requests
- **Request Details** - View URL, method, headers, body
- **Response Details** - View status code, headers, body, duration
- **Dio Interceptor** - `DebugHubDioInterceptor` for Dio integration
- **HTTP Client** - `DebugHttpClient` for HTTP package integration
- **cURL Export** - Share requests as cURL commands
- **Search & Filter** - Find specific requests quickly
- **Request/Response Formatting** - JSON pretty-printing

#### Logging System
- **Multiple Log Levels** - Verbose, Debug, Info, Warning, Error, WTF
- **Tag-Based Organization** - Categorize logs for easy filtering
- **Stack Trace Capture** - Full error context
- **Search Functionality** - Find logs instantly
- **Log Level Filtering** - Filter by severity
- **Tag Filtering** - Filter by category
- **Persistent Storage** - Logs survive app restarts
- **Export Capability** - Share logs easily
- **Timestamp Display** - Precise timing information

#### Crash Reporting
- **Non-Fatal Error Tracking** - Catch and log errors without crashing
- **Stack Trace Visualization** - Detailed error context
- **Error Categorization** - Organize crashes by type
- **Global Error Handlers** - Integration with Flutter error handling
- **Crash History** - View all reported crashes
- **Crash Details** - Full error information and context
- **Share Functionality** - Export crash reports

#### Analytics Event Tracking
- **Multi-Source Support** - Firebase, CleverTap, Custom events
- **Property Inspection** - View all event properties
- **Event History** - Track all logged events
- **Search & Filter** - Find specific events
- **Source Filtering** - Filter by event source
- **Event Details** - Complete property visualization
- **Export Events** - Share event data

#### Google Sheets Event Validation
- **Google Sign-In Integration** - OAuth 2.0 authentication
- **Sheet Version Management** - Version-based validation
- **Event Comparison** - Compare logged vs expected events
- **Statistics Dashboard** - View validation results and coverage
- **Missing Events Detection** - Identify events not logged
- **Extra Events Detection** - Identify unexpected events
- **Property Mismatch Detection** - Validate event properties
- **Validation Reports** - Comprehensive validation results
- **Master Sheet Support** - Multi-app configuration management

#### Notification Logging
- **Received Notifications** - Track all incoming notifications
- **Tapped Notifications** - Monitor user interactions
- **Payload Inspection** - View notification data
- **Firebase Integration** - Works seamlessly with FCM
- **Notification History** - Access past notifications
- **Search Functionality** - Find specific notifications
- **Notification Details** - Complete payload visualization

#### Device & App Information
- **Device Details** - Model, OS version, screen size
- **App Information** - Version, build number, package name
- **Memory Monitoring** - Real-time memory usage tracking
- **Storage Information** - Available and used storage
- **User Properties** - Custom user property display
- **Environment Info** - Debug/Release mode indication

#### Storage & Persistence
- **Hive-Based Storage** - Fast, reliable local storage
- **Data Persistence** - Survives app restarts
- **Automatic Cleanup** - Configurable data limits
- **Clear Functionality** - Easy data management
- **Storage Statistics** - View storage usage

#### UI & UX
- **Floating Bubble** - Draggable, always accessible
- **Bottom Navigation** - 5 main tabs (Network, Logs, Non-Fatal, Events, More)
- **Search Bars** - Search across all data types
- **Filter Options** - Multiple filtering capabilities
- **Share Functionality** - Export debug data
- **Clear Data** - Remove old debug information
- **Customizable Theme** - Custom primary color support
- **Responsive Design** - Works on all screen sizes
- **Dark Mode Ready** - Beautiful in any theme

### 🏗️ Architecture

#### Clean Architecture Implementation
- **Presentation Layer** - UI screens and widgets (`debug_hub_ui` package)
- **Application Layer** - Business logic and repositories (`events`, `notification`, `non_fatal` packages)
- **Domain Layer** - Entities and models (`base` package)
- **Infrastructure Layer** - Data sources and services (`network`, `log` packages)

#### SOLID Principles
- **Single Responsibility** - Each class has one reason to change
- **Open/Closed** - Open for extension, closed for modification
- **Liskov Substitution** - Subtypes are substitutable
- **Interface Segregation** - Clients depend only on what they use
- **Dependency Inversion** - Depend on abstractions

#### Design Patterns
- **Singleton Pattern** - Global state management
- **Repository Pattern** - Data access abstraction
- **Adapter Pattern** - HTTP client adaptation
- **Factory Pattern** - Object creation
- **Observer Pattern** - UI updates
- **Strategy Pattern** - Flexible implementations

### 📦 Package Structure

#### Core Packages
- **debug_hub** - Main package with simplified API
- **base** - Core models and storage (v1.0.0)
- **debug_hub_ui** - UI components and screens (v1.0.0)

#### Feature Packages
- **network** - Network monitoring (v1.0.0)
- **log** - Log tracking (v1.0.0)
- **events** - Event tracking and validation (v1.0.0)
- **notification** - Notification logging (v1.0.0)
- **non_fatal** - Crash reporting (v1.0.0)

### 🔧 API

#### DebugHubManager Methods
- `initialize()` - Initialize DebugHub with configuration
- `log()` - Log a message with optional tag and level
- `logError()` - Log an error with stack trace
- `trackEvent()` - Track an analytics event
- `logNotification()` - Log a received notification
- `logNotificationTap()` - Log a notification tap
- `reportCrash()` - Report a non-fatal crash
- `getObserver()` - Get NavigatorObserver for route tracking
- `clearAll()` - Clear all debug data
- `show()` - Show DebugHub screen manually
- `updateUserProperties()` - Update user properties dynamically
- `enableOnlyWithoutUI()` - Enable tracking without UI

#### Network Interceptors
- `DebugHubDioInterceptor` - Dio interceptor for automatic request capture
- `DebugHttpClient` - HTTP client wrapper for request capture

#### Event Tracking
- `EventTracker` - Main event tracking class
- `EventValidationRepository` - Google Sheets validation
- `GoogleSheetsService` - Google Sheets API integration

#### Storage
- `DebugStorage` - In-memory storage management
- `PersistentStorage` - Hive-based persistent storage

### 📚 Documentation

- **README.md** - Comprehensive documentation with examples
- **FEATURE_SUMMARY.md** - Manager-friendly feature summary
- **API_REFERENCE.md** - Detailed API documentation (archived)
- **ARCHITECTURE.md** - Architecture and design patterns (archived)
- **INTEGRATION_GUIDE.md** - Step-by-step integration guide (archived)
- **EVENT_VALIDATION_GUIDE.md** - Google Sheets validation guide (archived)
- **PERSISTENT_STORAGE_FEATURE.md** - Storage feature documentation (archived)
- **QUICK_GOOGLE_SIGNIN_SETUP.md** - Google Sign-In setup guide (archived)

### 🔒 Security & Safety

- **Production Safety** - Auto-disables in release builds using `kDebugMode`
- **No Data Leakage** - Only active in debug mode
- **No Performance Impact** - Zero overhead in production
- **Safe API** - All methods are no-ops in release mode

### 🎯 Platform Support

- **Android** - Full support (API 21+)
- **iOS** - Full support (iOS 12+)
- **Web** - Limited support (coming soon)
- **Desktop** - Not supported (coming soon)

### 📋 Requirements

- **Flutter** - 3.9.0 or higher
- **Dart** - 3.4.3 or higher
- **Android** - API Level 21 (Android 5.0) or higher
- **iOS** - iOS 12.0 or higher

### 🎨 Customization Options

- **Main Color** - Customize theme color
- **User Properties** - Add custom user properties
- **Bubble Position** - Draggable floating bubble
- **Tab Configuration** - Customize visible tabs

### 🐛 Known Issues

- None reported in initial release

### 📝 Notes

- This is the first stable release of DebugHub
- All core features are fully functional and tested
- Production-ready with comprehensive documentation
- Built with Clean Architecture and SOLID Principles
- Designed for easy integration and zero maintenance

### 🙏 Acknowledgments

- Built with Flutter and Dart
- Uses Hive for local storage
- Integrates with Dio and HTTP packages
- Google Sheets API for event validation
- Inspired by best practices in software architecture

---

## [Unreleased]

### 🚀 Planned Features

#### Platform Support
- [ ] Web platform support
- [ ] Windows desktop support
- [ ] macOS desktop support
- [ ] Linux desktop support

#### Advanced Features
- [ ] Remote debugging capabilities
- [ ] Performance monitoring (FPS, frame timing, jank detection)
- [ ] Custom plugins API
- [ ] Database inspector (SQLite, Hive)
- [ ] Shared Preferences viewer
- [ ] Widget inspector integration
- [ ] Timeline view for events
- [ ] Filtering presets
- [ ] Export to CSV/JSON/PDF
- [ ] AI-powered insights

#### Architecture Improvements
- [ ] Explicit Use Cases layer
- [ ] State management integration (Riverpod/Bloc)
- [ ] Dependency Injection container (GetIt)
- [ ] Comprehensive unit tests (>80% coverage)
- [ ] Widget tests for UI components
- [ ] Integration tests

#### UI/UX Enhancements
- [ ] Full dark mode support
- [ ] Customizable tab order
- [ ] Collapsible sections
- [ ] Advanced filtering options
- [ ] Keyboard shortcuts
- [ ] Accessibility improvements

---

## Version History

| Version | Release Date | Highlights |
|---------|--------------|------------|
| 1.0.0 | 2024-01-22 | Initial release with all core features |

---

## Migration Guides

### From Pre-Release to 1.0.0

This is the first stable release. No migration needed.

---

## Breaking Changes

### 1.0.0

No breaking changes (initial release).

---

## Deprecations

### 1.0.0

No deprecations (initial release).

---

## Support

For issues, questions, or feature requests:
- **GitHub Issues**: [Report a bug](https://github.com/yourusername/DebugHub/issues)
- **GitHub Discussions**: [Ask a question](https://github.com/yourusername/DebugHub/discussions)
- **Documentation**: See README.md for complete documentation

---

## License

MIT License - See [LICENSE](LICENSE) file for details.

---

**Note**: This changelog follows the [Keep a Changelog](https://keepachangelog.com/) format and uses [Semantic Versioning](https://semver.org/).

**Legend**:
- 🎉 Major release
- ✨ New features
- 🐛 Bug fixes
- 🔧 Changes
- 🗑️ Deprecations
- ❌ Removals
- 🔒 Security fixes
- 📚 Documentation
- 🏗️ Architecture
