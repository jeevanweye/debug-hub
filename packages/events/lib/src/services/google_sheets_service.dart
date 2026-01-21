import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/sheets/v4.dart' as sheets;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/master_sheet_info.dart';
import '../models/sheet_version_info.dart';
import '../models/event_report_info.dart';
import '../models/sheet_event_info.dart';

/// Service for interacting with Google Sheets API
class GoogleSheetsService {
  static final GoogleSheetsService _instance = GoogleSheetsService._internal();
  factory GoogleSheetsService() => _instance;
  GoogleSheetsService._internal() {
    // Set up listener once during construction
    _googleSignIn.onCurrentUserChanged.listen((GoogleSignInAccount? account) {
      _currentUser = account;
      if (account != null) {
        _initializeSheetsApi(account);
        debugPrint('✅ User signed in: ${account.email}');
      } else {
        _sheetsApi = null;
        debugPrint('ℹ️ User signed out');
      }
    });
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [sheets.SheetsApi.spreadsheetsScope],
  );

  sheets.SheetsApi? _sheetsApi;
  GoogleSignInAccount? _currentUser;
  bool _isInitialized = false;

  /// Initialize Google Sign-In
  Future<void> initialize() async {
    // Only initialize once
    if (_isInitialized) {
      debugPrint('ℹ️ GoogleSheetsService already initialized');
      return;
    }

    _isInitialized = true;

    // Try to sign in silently to restore previous session
    try {
      debugPrint('🔄 Attempting silent sign-in...');
      final account = await _googleSignIn.signInSilently();
      if (account != null) {
        _currentUser = account;
        await _initializeSheetsApi(account);
        debugPrint('✅ Silent sign-in successful: ${account.email}');
      } else {
        debugPrint('ℹ️ No previous sign-in found');
      }
    } catch (e) {
      debugPrint('⚠️ Silent sign-in failed: $e');
      // Silent sign-in failure is not critical, user can sign in manually
    }
  }

  /// Sign in with Google
  Future<GoogleSignInAccount?> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      if (account != null) {
        await _initializeSheetsApi(account);
      }
      return account;
    } on PlatformException catch (e) {
      debugPrint('Error signing in: $e');
      // Error code 10 = DEVELOPER_ERROR (configuration issue)
      if (e.code == 'sign_in_failed' && e.message?.contains('10') == true) {
        debugPrint('⚠️ DEVELOPER_ERROR: Google Sign-In configuration issue');
        debugPrint('💡 Common causes:');
        debugPrint('   1. SHA-1 fingerprint not added to Firebase/Google Cloud Console');
        debugPrint('   2. OAuth client ID not configured correctly');
        debugPrint('   3. Package name mismatch');
        debugPrint('   4. Missing google-services.json file');
        debugPrint('💡 See GOOGLE_SIGN_IN_SETUP.md for setup instructions');
      }
      rethrow;
    } catch (error) {
      debugPrint('Error signing in: $error');
      rethrow;
    }
  }

  /// Sign out (keeps credentials for silent sign-in)
  Future<void> signOut() async {
    try {
      debugPrint('🔄 Signing out...');
      await _googleSignIn.signOut();
      _sheetsApi = null;
      _currentUser = null;
      debugPrint('✅ Signed out successfully');
    } catch (e) {
      debugPrint('⚠️ Sign out error: $e');
      rethrow;
    }
  }

  /// Disconnect completely (removes all credentials)
  Future<void> disconnect() async {
    try {
      debugPrint('🔄 Disconnecting...');
      await _googleSignIn.disconnect();
      _sheetsApi = null;
      _currentUser = null;
      debugPrint('✅ Disconnected successfully');
    } catch (e) {
      debugPrint('⚠️ Disconnect error: $e');
      rethrow;
    }
  }

  /// Check if user is signed in
  bool get isSignedIn => _currentUser != null;

  /// Get current user
  GoogleSignInAccount? get currentUser => _currentUser;

  /// Check if service is initialized
  bool get isInitialized => _isInitialized;

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

