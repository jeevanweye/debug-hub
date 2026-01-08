import 'dart:io';

class StorageUtils {
  static Future<int> getDirectorySize(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) return 0;

      int totalSize = 0;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          try {
            totalSize += await entity.length();
          } catch (e) {
            // Skip files we can't read
          }
        }
      }
      return totalSize;
    } catch (e) {
      return 0;
    }
  }

  static Future<int> countFiles(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) return 0;

      int count = 0;
      await for (final entity in directory.list(recursive: true)) {
        if (entity is File) {
          count++;
        }
      }
      return count;
    } catch (e) {
      return 0;
    }
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  static bool isValidPath(String path) {
    try {
      final entity = FileSystemEntity.typeSync(path);
      return entity != FileSystemEntityType.notFound;
    } catch (e) {
      return false;
    }
  }
}

