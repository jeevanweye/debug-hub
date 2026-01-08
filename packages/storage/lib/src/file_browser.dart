import 'dart:io';
import 'file_info.dart';

class FileBrowser {
  static final FileBrowser _instance = FileBrowser._internal();
  factory FileBrowser() => _instance;
  FileBrowser._internal();

  Future<List<FileInfo>> listDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (!await directory.exists()) {
        return [];
      }

      final entities = await directory.list().toList();
      final fileInfos = entities.map((e) => FileInfo.fromFileSystemEntity(e)).toList();

      // Sort: directories first, then files, alphabetically
      fileInfos.sort((a, b) {
        if (a.type == FileType.directory && b.type != FileType.directory) {
          return -1;
        }
        if (a.type != FileType.directory && b.type == FileType.directory) {
          return 1;
        }
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });

      return fileInfos;
    } catch (e) {
      return [];
    }
  }

  Future<String?> readTextFile(String path) async {
    try {
      final file = File(path);
      if (!await file.exists()) return null;
      return await file.readAsString();
    } catch (e) {
      return null;
    }
  }

  Future<bool> writeTextFile(String path, String content) async {
    try {
      final file = File(path);
      await file.writeAsString(content);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteDirectory(String path) async {
    try {
      final directory = Directory(path);
      if (await directory.exists()) {
        await directory.delete(recursive: true);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  Future<bool> createDirectory(String path) async {
    try {
      final directory = Directory(path);
      await directory.create(recursive: true);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String?> getAppDocumentsDirectory() async {
    try {
      // This will be implemented with path_provider in the main app
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<String?> getAppCacheDirectory() async {
    try {
      // This will be implemented with path_provider in the main app
      return null;
    } catch (e) {
      return null;
    }
  }
}

