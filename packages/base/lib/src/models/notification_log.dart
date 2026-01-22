/// Notification log model
/// Tracks notifications received and tapped
class NotificationLog {
  final String id;
  final DateTime timestamp;
  final NotificationType type;
  final String? title;
  final String? body;
  final Map<String, dynamic>? payload;
  final String? notificationId;
  final bool wasTapped;
  final DateTime? tappedAt;

  NotificationLog({
    required this.id,
    required this.timestamp,
    required this.type,
    this.title,
    this.body,
    this.payload,
    this.notificationId,
    this.wasTapped = false,
    this.tappedAt,
  });

  factory NotificationLog.createReceived({
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
    String? notificationSource,
  }) {
    return NotificationLog(
      id: '${DateTime.now().millisecondsSinceEpoch}_${notificationId ?? 'unknown'}',
      timestamp: DateTime.now(),
      type: NotificationType.received,
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
      wasTapped: false,
    );
  }

  factory NotificationLog.createTapped({
    required String notificationId,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
  }) {
    return NotificationLog(
      id: '${DateTime.now().millisecondsSinceEpoch}_${notificationId}_tapped',
      timestamp: DateTime.now(),
      type: NotificationType.tapped,
      title: title,
      body: body,
      payload: payload,
      notificationId: notificationId,
      wasTapped: true,
      tappedAt: DateTime.now(),
    );
  }

  NotificationLog copyWith({
    String? id,
    DateTime? timestamp,
    NotificationType? type,
    String? title,
    String? body,
    Map<String, dynamic>? payload,
    String? notificationId,
    bool? wasTapped,
    DateTime? tappedAt,
  }) {
    return NotificationLog(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
      notificationId: notificationId ?? this.notificationId,
      wasTapped: wasTapped ?? this.wasTapped,
      tappedAt: tappedAt ?? this.tappedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'type': type.name,
      'title': title,
      'body': body,
      'payload': payload,
      'notificationId': notificationId,
      'wasTapped': wasTapped,
      'tappedAt': tappedAt?.toIso8601String(),
    };
  }

  factory NotificationLog.fromJson(Map<String, dynamic> json) {
    return NotificationLog(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      type: NotificationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => NotificationType.received,
      ),
      title: json['title'] as String?,
      body: json['body'] as String?,
      payload: json['payload'] as Map<String, dynamic>?,
      notificationId: json['notificationId'] as String?,
      wasTapped: json['wasTapped'] as bool? ?? false,
      tappedAt: json['tappedAt'] != null
          ? DateTime.parse(json['tappedAt'] as String)
          : null,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('NotificationLog(');
    buffer.write('type: ${type.name}, ');
    buffer.write('title: $title, ');
    buffer.write('body: $body, ');
    buffer.write('wasTapped: $wasTapped');
    if (payload != null) {
      buffer.write(', payload: $payload');
    }
    buffer.write(')');
    return buffer.toString();
  }
}

enum NotificationType {
  received,
  tapped,
}

