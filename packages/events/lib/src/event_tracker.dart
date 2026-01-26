import 'package:base/base.dart';

class EventTracker {
  static final EventTracker _instance = EventTracker._internal();
  factory EventTracker() => _instance;
  EventTracker._internal();

  final DebugStorage _storage = DebugStorage();
  bool _isEnabled = false;
  String? _currentUserId;
  String? _currentSessionId;

  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = false;
  }

  bool get isEnabled => _isEnabled;

  void setUserId(String? userId) {
    _currentUserId = userId;
  }

  void setSessionId(String? sessionId) {
    _currentSessionId = sessionId;
  }

  /// Track an analytics event
  void trackEvent(
    String name, {
    Map<String, dynamic>? properties,
    String? source,
    String? userId,
    String? sessionId,
  }) {
    if (!_isEnabled) return;

    final event = AnalyticsEvent.create(
      name: name,
      properties: properties,
      source: source,
      userId: userId ?? _currentUserId,
      sessionId: sessionId ?? _currentSessionId,
    );

    _storage.addEvent(event);
  }

  /// Track a CleverTap event
  void trackCleverTapEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) {
    trackEvent(name, properties: properties, source: 'CleverTap');
  }

  /// Track a Firebase event
  void trackFirebaseEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) {
    trackEvent(name, properties: properties, source: 'Firebase');
  }

  /// Track a custom event
  void trackCustomEvent(
    String name, {
    Map<String, dynamic>? properties,
  }) {
    trackEvent(name, properties: properties, source: 'Custom');
  }

  /// Get all tracked events
  List<AnalyticsEvent> getEvents() => _storage.getEvents();

  /// Clear all events
  void clearEvents() => _storage.clearEvents();
}

