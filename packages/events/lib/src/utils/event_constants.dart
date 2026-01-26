/// Constants for event validation and Google Sheets integration
class EventConstants {
  EventConstants._();

  /// Base Google Sheet ID for master configuration
  /// This sheet contains the mapping of package names to their respective event sheets
  static const String baseSheetId = '1lHKA_FOM_7RS9muCHdmSOkv7X7-6cDCgFVNxYx5SX7g';
  
  /// Range in the master sheet to read configuration
  static const String baseSheetRange = 'app_sheet!A2:E';
  
  /// Key for storing version name in preferences
  static const String versionNameKey = 'version_name';
  
  /// Key for storing event report details
  static const String eventReportDetailsKey = 'event_report_details';
}

