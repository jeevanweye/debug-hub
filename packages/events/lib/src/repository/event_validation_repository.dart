import 'package:base/base.dart';
import '../models/master_sheet_info.dart';
import '../models/sheet_version_info.dart';
import '../models/event_report_info.dart';
import '../services/google_sheets_service.dart';
import '../utils/event_comparator.dart';
import '../utils/event_constants.dart';

/// Repository for event validation operations
/// Handles fetching data from Google Sheets and comparing with local events
class EventValidationRepository {
  final GoogleSheetsService _sheetsService;
  final DebugStorage _storage;

  EventValidationRepository({
    GoogleSheetsService? sheetsService,
    DebugStorage? storage,
  })  : _sheetsService = sheetsService ?? GoogleSheetsService(),
        _storage = storage ?? DebugStorage();

  /// Initialize the repository and attempt silent sign-in
  Future<void> initialize() async {
    await _sheetsService.initialize();
  }

  /// Get master sheet configuration for the current app
  Future<List<MasterSheetInfo>> getMasterSheetInfo() async {
    return await _sheetsService.getMasterSheetInfo(
      baseSheetId: EventConstants.baseSheetId,
      baseSheetRange: EventConstants.baseSheetRange,
    );
  }

  /// Find sheet configuration for a specific package name
  MasterSheetInfo? findSheetForPackage({
    required List<MasterSheetInfo> masterSheets,
    required String packageName,
  }) {
    try {
      return masterSheets.firstWhere(
        (sheet) => sheet.packageName == packageName,
      );
    } catch (e) {
      return null;
    }
  }

  /// Get available versions (tabs) from the configured sheet
  Future<List<SheetVersionInfo>> getSheetVersions({
    required String sheetId,
  }) async {
    return await _sheetsService.getSheetVersions(sheetId: sheetId);
  }

  /// Get event data from a specific version/tab
  Future<List<EventReportInfo>> getSheetEventData({
    required String sheetId,
    required String versionName,
    required String range,
  }) async {
    return await _sheetsService.getSheetEventData(
      sheetId: sheetId,
      versionName: versionName,
      range: range,
    );
  }

  /// Validate events by comparing sheet events with logged events
  Future<List<EventReportInfo>> validateEvents({
    required List<EventReportInfo> sheetEvents,
  }) async {
    // Get logged events from storage
    final loggedEvents = _storage.getEvents();

    // Compare events
    final validatedEvents = EventComparator.compareEvents(
      loggedEvents: loggedEvents,
      sheetEvents: sheetEvents,
    );

    return validatedEvents;
  }

  /// Get comparison statistics
  EventComparisonStats getComparisonStats(List<EventReportInfo> reports) {
    return EventComparator.getStats(reports);
  }

  /// Sign in to Google account
  Future<bool> signIn() async {
    final account = await _sheetsService.signIn();
    return account != null;
  }

  /// Sign out from Google account
  Future<void> signOut() async {
    await _sheetsService.signOut();
  }

  /// Check if user is signed in
  bool get isSignedIn => _sheetsService.isSignedIn;

  /// Get current user email
  String? get currentUserEmail => _sheetsService.currentUser?.email;
}

