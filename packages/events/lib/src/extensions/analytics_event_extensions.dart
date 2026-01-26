import 'package:base/base.dart';

/// Extensions for AnalyticsEvent to support Google Sheets format
extension AnalyticsEventSheetExtensions on AnalyticsEvent {
  /// Get event action from properties
  String? get eventAction =>
      properties?['event_action']?.toString() ??
      properties?['event_type']?.toString();

  /// Get event category from properties
  String? get eventCategory => properties?['event_category']?.toString();

  /// Get screen name from properties
  String? get screenName =>
      properties?['screen_name']?.toString() ??
      properties?['module']?.toString();

  /// Get vehicle ID from properties
  String? get vehicleId =>
      properties?['vehicle_id']?.toString() ??
      properties?['demand_id']?.toString();

  /// Get entity from properties
  String? get entity => properties?['entity']?.toString();

  /// Get miscellaneous from properties
  String? get miscellaneous => properties?['miscellaneous']?.toString();

  /// Get target product from properties
  String? get targetProduct => properties?['target_product']?.toString();

  /// Create AnalyticsEvent with Google Sheets compatible properties
  static AnalyticsEvent createWithSheetProperties({
    required String eventName,
    String? eventAction,
    String? eventCategory,
    String? screenName,
    String? vehicleId,
    String? entity,
    String? miscellaneous,
    String? targetProduct,
    String? source,
    String? userId,
    String? sessionId,
    Map<String, dynamic>? additionalProperties,
  }) {
    final properties = <String, dynamic>{
      if (eventAction != null) 'event_action': eventAction,
      if (eventCategory != null) 'event_category': eventCategory,
      if (screenName != null) 'screen_name': screenName,
      if (vehicleId != null) 'vehicle_id': vehicleId,
      if (entity != null) 'entity': entity,
      if (miscellaneous != null) 'miscellaneous': miscellaneous,
      if (targetProduct != null) 'target_product': targetProduct,
      if (additionalProperties != null) ...additionalProperties,
    };

    return AnalyticsEvent.create(
      name: eventName,
      properties: properties,
      source: source,
      userId: userId,
      sessionId: sessionId,
    );
  }
}

