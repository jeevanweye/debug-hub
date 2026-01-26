class AnalyticsEvent {
  final String id;
  final DateTime timestamp;
  final String name;
  final Map<String, dynamic>? properties;
  final String? source; // 'clevertap', 'firebase', 'custom', etc.
  final String? userId;
  final String? sessionId;

  AnalyticsEvent({
    required this.id,
    required this.timestamp,
    required this.name,
    this.properties,
    this.source,
    this.userId,
    this.sessionId,
  });

  factory AnalyticsEvent.create({
    required String name,
    Map<String, dynamic>? properties,
    String? source,
    String? userId,
    String? sessionId,
  }) {
    return AnalyticsEvent(
      id: '${DateTime.now().millisecondsSinceEpoch}_${name.hashCode}',
      timestamp: DateTime.now(),
      name: name,
      properties: properties,
      source: source,
      userId: userId,
      sessionId: sessionId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'timestamp': timestamp.toIso8601String(),
      'name': name,
      'properties': properties,
      'source': source,
      'userId': userId,
      'sessionId': sessionId,
    };
  }

  Map<String, dynamic> toJsonSharable() {
    return {
      'name': name,
      'properties': properties,
      'source': source,
    };
  }

  factory AnalyticsEvent.fromJson(Map<String, dynamic> json) {
    return AnalyticsEvent(
      id: json['id'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      name: json['name'] as String,
      properties: json['properties'] as Map<String, dynamic>?,
      source: json['source'] as String?,
      userId: json['userId'] as String?,
      sessionId: json['sessionId'] as String?,
    );
  }

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.write('Event: $name');
    if (source != null) buffer.write(' [$source]');
    if (properties != null && properties!.isNotEmpty) {
      buffer.write('\nProperties: $properties');
    }
    return buffer.toString();
  }
}

