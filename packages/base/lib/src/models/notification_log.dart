class NotificationLog {
  final String id;
  final DateTime timestamp;
  final NotificationSource source;
  final String? title;
  final String? body;
  final Map<String, dynamic>? payload;
  final String? notificationId;
  final NotificationMode mode;

  NotificationLog({
    required this.id,
    required this.timestamp,
    required this.source,
    this.title,
    this.body,
    this.payload,
    this.notificationId,
    required this.mode,
  });

  factory NotificationLog.createReceived({
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
    String? notificationSource,
    String? mode,
  }) {
    return NotificationLog(
      id: '${DateTime.now().millisecondsSinceEpoch}_${notificationId ?? 'unknown'}',
      timestamp: DateTime.now(),
      source: NotificationSource.values.byName(notificationSource ?? NotificationSource.firebase.name),
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
      mode:  NotificationMode.values.byName(mode ?? NotificationMode.foreground.name),
    );
  }



  NotificationLog copyWith({
    String? id,
    DateTime? timestamp,
    NotificationSource? source,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
    NotificationMode? mode,
  }) {
    return NotificationLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      source: source ?? this.source,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      notificationId: notificationId ?? this.notificationId,
      mode: mode ?? this.mode,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'source': source.name,
      'title': title,
      'body': body,
      'payload': payload,
      'notificationId': notificationId,
      'mode': mode.name,
    };
  }

  factory NotificationLog.fromJson(Map<String, dynamic> json) {
    return NotificationLog(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      source: NotificationSource.values.firstWhere(
            (e) => e.name == json['source'],
        orElse: () => NotificationSource.firebase,
      ),
      title: json['title'] as String?,
      body: json['body'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      notificationId: json['notificationId'] as String?,
      mode: NotificationMode.values.firstWhere(
            (e) => e.name == json['mode'],
        orElse: () => NotificationMode.foreground,
      ),
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('NotificationLog(');
    buffer.write('source: ${source.name}, ');
    buffer.write('title: $title, ');
    buffer.write('body: $body, ');
    if (payload != null) {
      buffer.write(', payload: $payload');
    }
    buffer.write('mode: ${mode.name}, ');
    buffer.write(')');
    return buffer.toString();
  }
}

enum NotificationMode {
  foreground,
  background,
}

enum NotificationSource {
  firebase,
  clevertap,
}
