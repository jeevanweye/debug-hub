import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../models/master_sheet_info.dart';
import '../models/sheet_version_info.dart';
import '../models/event_report_info.dart';
import '../models/sheet_event_info.dart';

/// Service for interacting with Google Sheets API
class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._internal();

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [sheets.SheetsApi.spreadsheetsScope],
  );

  sheets.SheetsApi? _sheetsApi;
  GoogleSignInAccount? _currentUser;

  /// Initialize Google Sign-In
  Future<void> initialize() async {
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      if (account != null) {
        _initializeSheetsApi(account);
      }
    });

    // Try to sign in silently
    await _googleSignIn.signInSilently();
  }

  /// Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        await _initializeSheetsApi(account);
      }
      return account;
    } catch (error) {
      debugPrint('Error signing in: $error');
      return null;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    _sheetsApi = null;
    _currentUser = null;
  }

  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;

  /// Get current user
  GoogleSignInAccount? get currentUser => _currentUser;

  Future<void> _initializeSheetsApi(GoogleSignInAccount account) async {
    final authHeaders = await account.authHeaders;
    final authenticateClient = _GoogleAuthClient(authHeaders);
    _sheetsApi = sheets.SheetsApi(authenticateClient);
  }

  /// Get master sheet information
  /// This retrieves the configuration for which sheet to use for the current app
  Future<List<MasterSheetInfo>> getMasterSheetInfo({
    required String baseSheetId,
    required String baseSheetRange,
  }) async {
    if (_sheetsApi == null) {
      throw Exception('Not signed in. Please sign in first.');
    }

    try {
      final response = await _sheetsApi!.spreadsheets.values.get(
        baseSheetId,
        baseSheetRange,
      );

      final values = response.values;
      if (values == null || values.isEmpty) {
        return [];
      }

      return values.map((row) => MasterSheetInfo.fromSheetRow(row)).toList();
    } catch (e) {
      debugPrint('Error getting master sheet info: $e');
      rethrow;
    }
  }

  /// Get sheet versions (tabs) from a spreadsheet
  Future<List<SheetVersionInfo>> getSheetVersions({
    required String sheetId,
  }) async {
    if (_sheetsApi == null) {
      throw Exception('Not signed in. Please sign in first.');
    }

    try {
      final spreadsheet = await _sheetsApi!.spreadsheets.get(
        sheetId,
        $fields: 'sheets(properties(title,sheetId,index))',
      );

      final sheetsList = spreadsheet.sheets;
      if (sheetsList == null || sheetsList.isEmpty) {
        return [];
      }

      return sheetsList.map((sheet) {
        final props = sheet.properties;
        return SheetVersionInfo(
          index: props?.index,
          title: props?.title,
          sheetId: props?.sheetId,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting sheet versions: $e');
      rethrow;
    }
  }

  /// Get event data from a specific sheet version
  Future<List<EventReportInfo>> getSheetEventData({
    required String sheetId,
    required String versionName,
    required String range,
  }) async {
    if (_sheetsApi == null) {
      throw Exception('Not signed in. Please sign in first.');
    }

    try {
      final fullRange = '$versionName$range';
      final response = await _sheetsApi!.spreadsheets.values.get(
        sheetId,
        fullRange,
      );

      final values = response.values;
      if (values == null || values.isEmpty) {
        return [];
      }

      return values.map((row) {
        return EventReportInfo(
          sheetEvent: SheetEventInfo.fromSheetRow(row),
          isFound: false,
          isCorrect: false,
        );
      }).toList();
    } catch (e) {
      debugPrint('Error getting sheet event data: $e');
      rethrow;
    }
  }
}

/// Custom HTTP client for Google API authentication
class _GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  _GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}

