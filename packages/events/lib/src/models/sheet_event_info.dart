import 'package:freezed_annotation/freezed_annotation.dart';

part 'sheet_event_info.freezed.dart';
part 'sheet_event_info.g.dart';

/// Event information model compatible with Google Sheets format
/// Similar to WeEventInfo from android_logger
@freezed
class SheetEventInfo with _$SheetEventInfo {
  const factory SheetEventInfo({
    @JsonKey(name: 'sn') String? serialNumber,
    @JsonKey(name: 'event_name') String? eventName,
    @JsonKey(name: 'event_action') String? eventAction,
    @JsonKey(name: 'event_category') String? eventCategory,
    @JsonKey(name: 'screen_name') String? screenName,
    @JsonKey(name: 'vehicle_id') String? vehicleId,
    @JsonKey(name: 'entity') String? entity,
    @JsonKey(name: 'miscellaneous') String? miscellaneous,
    @JsonKey(name: 'target_product') String? targetProduct,
  }) = _SheetEventInfo;

  factory SheetEventInfo.fromJson(Map<String, dynamic> json) {
    // Normalize JSON to handle both vehicle_id and demand_id
    final normalizedJson = Map<String, dynamic>.from(json);
    
    // Get vehicle_id value (may be null or empty)
    final vehicleIdValue = normalizedJson['vehicle_id'];
    final demandIdValue = normalizedJson['demand_id'];
    
    // Use demand_id if vehicle_id is missing, null, or empty
    if ((vehicleIdValue == null || 
         vehicleIdValue.toString().trim().isEmpty) && 
        demandIdValue != null && 
        demandIdValue.toString().trim().isNotEmpty) {
      normalizedJson['vehicle_id'] = demandIdValue;
    }
    
    // Call the generated implementation directly to avoid recursion
    return _$$SheetEventInfoImplFromJson(normalizedJson);
  }

  factory SheetEventInfo.fromSheetRow(List<dynamic> row) {
    return SheetEventInfo(
      serialNumber: _safeStringIndex(row, 0),
      eventName: _safeStringIndex(row, 1),
      eventAction: _safeStringIndex(row, 2),
      eventCategory: _safeStringIndex(row, 3),
      screenName: _safeStringIndex(row, 4),
      vehicleId: _safeStringIndex(row, 5),
      entity: _safeStringIndex(row, 6),
      miscellaneous: _safeStringIndex(row, 7),
      targetProduct: _safeStringIndex(row, 8),
    );
  }

  static String? _safeStringIndex(List<dynamic> list, int index) {
    if (index < list.length) {
      final value = list[index];
      return value?.toString();
    }
    return null;
  }
}

extension SheetEventInfoComparison on SheetEventInfo {
  /// Check if this event matches another event based on business logic
  bool matches(SheetEventInfo other) {
    if (eventName != other.eventName) return false;
    if (eventAction != other.eventAction) return false;
    if (eventCategory != other.eventCategory) return false;
    if (!_isScreenMatch(screenName, other.screenName)) return false;
    if (!_vehicleDemandIdCheck(vehicleId, other.vehicleId)) return false;
    if (!_misCheck(miscellaneous, other.miscellaneous)) return false;
    if (!_misCheck(entity, other.entity)) return false;
    return targetProduct == other.targetProduct;
  }

  bool _isScreenMatch(String? screen1, String? screen2) {
    // Handle dynamic screen names
    if (screen1 == 'dynamic' || 
        screen2 == 'dynamic' || 
        screen1 == "user's screen" || 
        screen2 == "user's screen") {
      return true;
    }
    return screen1 == screen2;
  }

  bool _vehicleDemandIdCheck(String? sheetVehicleId, String? logVehicleId) {
    if (sheetVehicleId?.toUpperCase() == 'YES') {
      return logVehicleId != null && logVehicleId.isNotEmpty;
    }
    return true;
  }

  bool _misCheck(String? sheetMis, String? logMis) {
    if (sheetMis == null || sheetMis.isEmpty) return true;
    if (logMis == null || logMis.isEmpty) return sheetMis.isEmpty;

    final sheetItems = sheetMis.split('::');
    final logItems = logMis.split('::');

    if (sheetItems.length != logItems.length) return false;

    return _misKeyMatch(sheetItems, logItems);
  }

  bool _misKeyMatch(List<String> sheetItems, List<String> logItems) {
    try {
      int matchCount = 0;
      for (final sheetItem in sheetItems) {
        final sheetKey = sheetItem.split(':').first;
        for (final logItem in logItems) {
          final logKey = logItem.split(':').first;
          if (sheetKey == logKey) {
            matchCount++;
            break;
          }
        }
      }
      return matchCount == sheetItems.length;
    } catch (e) {
      return false;
    }
  }
}

