import 'dart:io';

enum FileType {
  directory,
  file,
  unknown,
}

class FileInfo {
  final String name;
  final String path;
  final FileType type;
  final int? size;
  final DateTime? lastModified;
  final String? extension;

  FileInfo({
    required this.name,
    required this.path,
    required this.type,
    this.size,
    this.lastModified,
    this.extension,
  });

  factory FileInfo.fromFileSystemEntity(FileSystemEntity entity) {
    final stat = entity.statSync();
    final name = entity.path.split('/').last;
    
    FileType type;
    if (entity is Directory) {
      type = FileType.directory;
    } else if (entity is File) {
      type = FileType.file;
    } else {
      type = FileType.unknown;
    }

    String? extension;
    if (type == FileType.file && name.contains('.')) {
      extension = name.split('.').last;
    }

    return FileInfo(
      name: name,
      path: entity.path,
      type: type,
      size: stat.size,
      lastModified: stat.modified,
      extension: extension,
    );
  }

  String get formattedSize {
    if (size == null) return '-';
    if (size! < 1024) return '$size B';
    if (size! < 1024 * 1024) return '${(size! / 1024).toStringAsFixed(2)} KB';
    if (size! < 1024 * 1024 * 1024) {
      return '${(size! / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(size! / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }

  bool get isTextFile {
    if (type != FileType.file || extension == null) return false;
    const textExtensions = [
      'txt', 'json', 'xml', 'html', 'css', 'js', 'dart',
      'yaml', 'yml', 'md', 'log', 'csv', 'sql',
    ];
    return textExtensions.contains(extension!.toLowerCase());
  }

  bool get isImageFile {
    if (type != FileType.file || extension == null) return false;
    const imageExtensions = ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'webp', 'svg'];
    return imageExtensions.contains(extension!.toLowerCase());
  }
}

