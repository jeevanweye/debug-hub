import 'package:base/base.dart';
import '../models/event_report_info.dart';
import '../models/sheet_event_info.dart';

/// Utility class for comparing events between device logs and Google Sheets
class EventComparator {
  /// Compare logged events with sheet events
  /// Returns updated list of EventReportInfo with comparison results
  static List<EventReportInfo> compareEvents({
    required List<AnalyticsEvent> loggedEvents,
    required List<EventReportInfo> sheetEvents,
  }) {
    final updatedSheetEvents = <EventReportInfo>[];

    for (final sheetEventInfo in sheetEvents) {
      final sheetEvent = sheetEventInfo.sheetEvent;
      if (sheetEvent == null) {
        updatedSheetEvents.add(sheetEventInfo);
        continue;
      }

      bool found = false;
      SheetEventInfo? matchedDevEvent;
      bool isCorrect = false;
      // Try to find matching event in logged events
      for (final loggedEvent in loggedEvents) {
        final devEvent = _convertAnalyticsEventToSheetEvent(loggedEvent);
        if (sheetEvent.matches(devEvent)) {
          found = true;
          matchedDevEvent = devEvent;
          isCorrect = true;
          break;
        } else if (_eventsMatch(sheetEvent, devEvent)) {
          found = true;
          matchedDevEvent = devEvent;
        }
      }

      updatedSheetEvents.add(
        sheetEventInfo.copyWith(
          devEvent: matchedDevEvent,
          isFound: found,
          isCorrect: isCorrect,
        ),
      );
    }

    return updatedSheetEvents;
  }

  /// Check if two events match based on event name
  static bool _eventsMatch(SheetEventInfo sheetEvent, SheetEventInfo devEvent) {
    return sheetEvent.eventName == devEvent.eventName && sheetEvent.screenName == devEvent.screenName;
  }

  /// Convert AnalyticsEvent to SheetEventInfo for comparison
  static SheetEventInfo _convertAnalyticsEventToSheetEvent(
    AnalyticsEvent event,
  ) {
    final properties = event.properties ?? {};
    
    return SheetEventInfo(
      eventName: event.name,
      eventAction: properties['event_action']?.toString() ?? 
                   properties['event_type']?.toString(),
      eventCategory: properties['event_category']?.toString(),
      screenName: properties['screen_name']?.toString() ?? 
                  properties['module']?.toString(),
      vehicleId: properties['vehicle_id']?.toString() ?? 
                 properties['demand_id']?.toString(),
      entity: properties['entity']?.toString(),
      miscellaneous: properties['miscellaneous']?.toString(),
      targetProduct: properties['target_product']?.toString(),
    );
  }

  /// Get statistics from comparison results
  static EventComparisonStats getStats(List<EventReportInfo> reports) {
    int total = reports.length;
    int found = reports.where((r) => r.isFound).length;
    int correct = reports.where((r) => r.isCorrect).length;
    int notFound = total - found;
    int foundButIncorrect = found - correct;

    return EventComparisonStats(
      total: total,
      found: found,
      correct: correct,
      notFound: notFound,
      foundButIncorrect: foundButIncorrect,
    );
  }
}

/// Statistics for event comparison
class EventComparisonStats {
  final int total;
  final int found;
  final int correct;
  final int notFound;
  final int foundButIncorrect;

  EventComparisonStats({
    required this.total,
    required this.found,
    required this.correct,
    required this.notFound,
    required this.foundButIncorrect,
  });

  double get foundPercentage => total > 0 ? (found / total) * 100 : 0;
  double get correctPercentage => total > 0 ? (correct / total) * 100 : 0;
  double get notFoundPercentage => total > 0 ? (notFound / total) * 100 : 0;
  double get foundButIncorrectPercentage => 
      total > 0 ? (foundButIncorrect / total) * 100 : 0;
}

