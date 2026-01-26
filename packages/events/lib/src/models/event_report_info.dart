import 'package:freezed_annotation/freezed_annotation.dart';
import 'sheet_event_info.dart';

part 'event_report_info.freezed.dart';
part 'event_report_info.g.dart';

/// Model to hold comparison results between sheet events and logged events
@freezed
class EventReportInfo with _$EventReportInfo {
  const factory EventReportInfo({
    /// Event from Google Sheet
    SheetEventInfo? sheetEvent,
    
    /// Event from device logs
    SheetEventInfo? devEvent,
    
    /// Whether the event was found in device logs
    @Default(false) bool isFound,
    
    /// Whether the event matches exactly
    @Default(false) bool isCorrect,
  }) = _EventReportInfo;

  factory EventReportInfo.fromJson(Map<String, dynamic> json) =>
      _$EventReportInfoFromJson(json);
}

