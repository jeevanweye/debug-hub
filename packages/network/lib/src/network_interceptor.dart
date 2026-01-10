import 'dart:convert';
import 'package:base/base.dart';

class NetworkInterceptor {
  static final NetworkInterceptor _instance = NetworkInterceptor._internal();
  factory NetworkInterceptor() => _instance;
  NetworkInterceptor._internal();

  final DebugStorage _storage = DebugStorage();
  bool _isEnabled = false;

  void enable() {
    _isEnabled = true;
  }

  void disable() {
    _isEnabled = false;
  }

  bool get isEnabled => _isEnabled;

  String captureRequest({
    required String url,
    required String method,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_isEnabled) return '';

    final id = '${DateTime.now().millisecondsSinceEpoch}_${url.hashCode}';
    final request = NetworkRequest(
      id: id,
      timestamp: DateTime.now(),
      url: url,
      method: _parseMethod(method),
      headers: headers,
      requestBody: body,
      requestSize: _calculateSize(body),
    );

    _storage.addNetworkRequest(request);
    return id;
  }

  void updateRequest({
    required String id,
    String? method,
    Map<String, dynamic>? headers,
    dynamic body,
  }) {
    if (!_isEnabled) return;
    final existingRequest = _storage.getNetworkRequestById(id);
    if (existingRequest != null) {
      final updatedRequest = existingRequest.copyWith(
        id: id,
        headers: headers,
        requestBody: body,
        requestSize: _calculateSize(body),
      );
      _storage.updateNetworkRequest(id, updatedRequest);
    }
  }

  void captureResponse({
    required String id,
    int? statusCode,
    dynamic responseBody,
    Map<String, dynamic>? responseHeaders,
    Duration? duration,
    String? error,
  }) {
    if (!_isEnabled) return;

    final existingRequest = _storage.getNetworkRequestById(id);
    if (existingRequest != null) {
      final updatedRequest = existingRequest.copyWith(
        statusCode: statusCode,
        responseBody: responseBody,
        responseHeaders: responseHeaders,
        duration: duration,
        error: error,
        responseSize: _calculateSize(responseBody),
      );
      _storage.updateNetworkRequest(id, updatedRequest);
    }
  }

  RequestMethod _parseMethod(String method) {
    switch (method.toUpperCase()) {
      case 'GET':
        return RequestMethod.get;
      case 'POST':
        return RequestMethod.post;
      case 'PUT':
        return RequestMethod.put;
      case 'PATCH':
        return RequestMethod.patch;
      case 'DELETE':
        return RequestMethod.delete;
      case 'HEAD':
        return RequestMethod.head;
      case 'OPTIONS':
        return RequestMethod.options;
      default:
        return RequestMethod.get;
    }
  }

  int _calculateSize(dynamic data) {
    if (data == null) return 0;
    try {
      if (data is String) {
        return utf8.encode(data).length;
      } else if (data is List<int>) {
        return data.length;
      } else {
        return utf8.encode(jsonEncode(data)).length;
      }
    } catch (e) {
      return 0;
    }
  }
}

