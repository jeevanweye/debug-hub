class CrashReport {
  final String id;
  final DateTime timestamp;
  final String error;
  final StackTrace? stackTrace;
  final String? context;
  final Map<String, dynamic>? deviceInfo;
  final bool isFatal;

  CrashReport({
    required this.id,
    required this.timestamp,
    required this.error,
    this.stackTrace,
    this.context,
    this.deviceInfo,
    this.isFatal = false,
  });

  factory CrashReport.create({
    required String error,
    StackTrace? stackTrace,
    String? context,
    Map<String, dynamic>? deviceInfo,
    bool isFatal = false,
  }) {
    return CrashReport(
      id: '${DateTime.now().millisecondsSinceEpoch}_${error.hashCode}',
      timestamp: DateTime.now(),
      error: error,
      stackTrace: stackTrace,
      context: context,
      deviceInfo: deviceInfo,
      isFatal: isFatal,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'error': error,
      'stackTrace': stackTrace?.toString(),
      'context': context,
      'deviceInfo': deviceInfo,
      'isFatal': isFatal,
    };
  }

  factory CrashReport.fromJson(Map<String, dynamic> json) {
    return CrashReport(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      error: json['error'] as String,
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      context: json['context'] as String?,
      deviceInfo: json['deviceInfo'] as Map<String, dynamic>?,
      isFatal: json['isFatal'] as bool? ?? false,
    );
  }
}

