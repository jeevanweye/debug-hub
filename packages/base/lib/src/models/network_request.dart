import 'dart:convert';

enum RequestMethod {
  get,
  post,
  put,
  patch,
  delete,
  head,
  options,
}

class NetworkRequest {
  final String id;
  final DateTime timestamp;
  final String url;
  final RequestMethod method;
  final Map<String, dynamic>? headers;
  final dynamic requestBody;
  final int? statusCode;
  final dynamic responseBody;
  final Map<String, dynamic>? responseHeaders;
  final Duration? duration;
  final String? error;
  final int? requestSize;
  final int? responseSize;

  NetworkRequest({
    required this.id,
    required this.timestamp,
    required this.url,
    required this.method,
    this.headers,
    this.requestBody,
    this.statusCode,
    this.responseBody,
    this.responseHeaders,
    this.duration,
    this.error,
    this.requestSize,
    this.responseSize,
  });

  bool get isSuccess => statusCode != null && statusCode! >= 200 && statusCode! < 300;
  bool get isError => error != null || (statusCode != null && statusCode! >= 400);
  bool get isPending => statusCode == null && error == null;

  NetworkRequest copyWith({
    String? id,
    DateTime? timestamp,
    String? url,
    RequestMethod? method,
    Map<String, dynamic>? headers,
    dynamic requestBody,
    int? statusCode,
    dynamic responseBody,
    Map<String, dynamic>? responseHeaders,
    Duration? duration,
    String? error,
    int? requestSize,
    int? responseSize,
  }) {
    return NetworkRequest(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      url: url ?? this.url,
      method: method ?? this.method,
      headers: headers ?? this.headers,
      requestBody: requestBody ?? this.requestBody,
      statusCode: statusCode ?? this.statusCode,
      responseBody: responseBody ?? this.responseBody,
      responseHeaders: responseHeaders ?? this.responseHeaders,
      duration: duration ?? this.duration,
      error: error ?? this.error,
      requestSize: requestSize ?? this.requestSize,
      responseSize: responseSize ?? this.responseSize,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'url': url,
      'method': method.name,
      'headers': headers,
      'requestBody': _serializeBody(requestBody),
      'statusCode': statusCode,
      'responseBody': _serializeBody(responseBody),
      'responseHeaders': responseHeaders,
      'duration': duration?.inMilliseconds,
      'error': error,
      'requestSize': requestSize,
      'responseSize': responseSize,
    };
  }

  factory NetworkRequest.fromJson(Map<String, dynamic> json) {
    return NetworkRequest(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      url: json['url'] as String,
      method: RequestMethod.values.firstWhere(
        (e) => e.name == json['method'],
        orElse: () => RequestMethod.get,
      ),
      headers: json['headers'] as Map<String, dynamic>?,
      requestBody: json['requestBody'],
      statusCode: json['statusCode'] as int?,
      responseBody: json['responseBody'],
      responseHeaders: json['responseHeaders'] as Map<String, dynamic>?,
      duration: json['duration'] != null
          ? Duration(milliseconds: json['duration'] as int)
          : null,
      error: json['error'] as String?,
      requestSize: json['requestSize'] as int?,
      responseSize: json['responseSize'] as int?,
    );
  }

  static dynamic _serializeBody(dynamic body) {
    if (body == null) return null;
    if (body is String) return body;
    if (body is Map || body is List) {
      try {
        return jsonEncode(body);
      } catch (e) {
        return body.toString();
      }
    }
    return body.toString();
  }

  String getFormattedRequestBody() {
    return _formatBody(requestBody);
  }

  String getFormattedResponseBody() {
    return _formatBody(responseBody);
  }

  String _formatBody(dynamic body) {
    if (body == null) return '';
    if (body is String) {
      try {
        final decoded = jsonDecode(body);
        return JsonEncoder.withIndent('  ').convert(decoded);
      } catch (e) {
        return body;
      }
    }
    try {
      return JsonEncoder.withIndent('  ').convert(body);
    } catch (e) {
      return body.toString();
    }
  }
}

