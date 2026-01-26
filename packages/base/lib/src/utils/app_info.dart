import 'package:package_info_plus/package_info_plus.dart';

class AppInfo {
  static Future<String?> getPackageName() async {
    try {
      final packageInfo = await PackageInfo.fromPlatform();
      return packageInfo.packageName;
    } catch (e) {
      return null;
    }
  }
}