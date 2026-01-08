class DeviceInfo {
  final String? deviceModel;
  final String? osVersion;
  final String? platform;
  final String? appVersion;
  final String? appBuildNumber;
  final String? packageName;
  final double? screenWidth;
  final double? screenHeight;
  final double? pixelRatio;
  final String? locale;
  final Map<String, dynamic>? additionalInfo;

  DeviceInfo({
    this.deviceModel,
    this.osVersion,
    this.platform,
    this.appVersion,
    this.appBuildNumber,
    this.packageName,
    this.screenWidth,
    this.screenHeight,
    this.pixelRatio,
    this.locale,
    this.additionalInfo,
  });

  Map<String, dynamic> toJson() {
    return {
      'deviceModel': deviceModel,
      'osVersion': osVersion,
      'platform': platform,
      'appVersion': appVersion,
      'appBuildNumber': appBuildNumber,
      'packageName': packageName,
      'screenWidth': screenWidth,
      'screenHeight': screenHeight,
      'pixelRatio': pixelRatio,
      'locale': locale,
      'additionalInfo': additionalInfo,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      deviceModel: json['deviceModel'] as String?,
      osVersion: json['osVersion'] as String?,
      platform: json['platform'] as String?,
      appVersion: json['appVersion'] as String?,
      appBuildNumber: json['appBuildNumber'] as String?,
      packageName: json['packageName'] as String?,
      screenWidth: json['screenWidth'] as double?,
      screenHeight: json['screenHeight'] as double?,
      pixelRatio: json['pixelRatio'] as double?,
      locale: json['locale'] as String?,
      additionalInfo: json['additionalInfo'] as Map<String, dynamic>?,
    );
  }
}

