enum LogLevel {
  verbose,
  debug,
  info,
  warning,
  error,
  wtf, // What a Terrible Failure
}

class DebugLog {
  final String id;
  final DateTime timestamp;
  final LogLevel level;
  final String message;
  final String? tag;
  final dynamic error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;

  DebugLog({
    required this.id,
    required this.timestamp,
    required this.level,
    required this.message,
    this.tag,
    this.error,
    this.stackTrace,
    this.metadata,
  });

  factory DebugLog.create({
    required LogLevel level,
    required String message,
    String? tag,
    dynamic error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
  }) {
    return DebugLog(
      id: '${DateTime.now().millisecondsSinceEpoch}_${message.hashCode}',
      timestamp: DateTime.now(),
      level: level,
      message: message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'level': level.name,
      'message': message,
      'tag': tag,
      'error': error?.toString(),
      'stackTrace': stackTrace?.toString(),
      'metadata': metadata,
    };
  }

  factory DebugLog.fromJson(Map<String, dynamic> json) {
    return DebugLog(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      level: LogLevel.values.firstWhere(
        (e) => e.name == json['level'],
        orElse: () => LogLevel.debug,
      ),
      message: json['message'] as String,
      tag: json['tag'] as String?,
      error: json['error'],
      stackTrace: json['stackTrace'] != null
          ? StackTrace.fromString(json['stackTrace'] as String)
          : null,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('[${level.name.toUpperCase()}]');
    if (tag != null) buffer.write(' [$tag]');
    buffer.write(' $message');
    if (error != null) buffer.write('\nError: $error');
    if (stackTrace != null) buffer.write('\n$stackTrace');
    return buffer.toString();
  }
}

