import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import '../debug_hub_config.dart';

class StorageScreen extends StatefulWidget {
  final DebugHubConfig config;

  const StorageScreen({
    super.key,
    required this.config,
  });

  @override
  State<StorageScreen> createState() => _StorageScreenState();
}

class _StorageScreenState extends State<StorageScreen> {
  Directory? _currentDirectory;
  List<FileSystemEntity> _files = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadDocumentsDirectory();
  }

  Future<void> _loadDocumentsDirectory() async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      _loadDirectory(directory);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading directory: $e')),
        );
      }
    }
  }

  Future<void> _loadDirectory(Directory directory) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final files = directory.listSync()
        ..sort((a, b) {
          // Directories first, then files
          if (a is Directory && b is File) return -1;
          if (a is File && b is Directory) return 1;
          return a.path.compareTo(b.path);
        });

      setState(() {
        _currentDirectory = directory;
        _files = files;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading directory: $e')),
        );
      }
    }
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String _getFileName(String path) {
    return path.split('/').last;
  }

  Future<void> _showStorageInfo() async {
    final appDir = await getApplicationDocumentsDirectory();
    final tempDir = await getTemporaryDirectory();
    
    int calculateDirectorySize(Directory dir) {
      int size = 0;
      try {
        dir.listSync(recursive: true).forEach((entity) {
          if (entity is File) {
            try {
              size += entity.lengthSync();
            } catch (_) {}
          }
        });
      } catch (_) {}
      return size;
    }

    final appSize = calculateDirectorySize(appDir);
    final tempSize = calculateDirectorySize(tempDir);

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Storage Info'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoRow('Documents', appDir.path),
            _buildInfoRow('Size', _formatFileSize(appSize)),
            const Divider(),
            _buildInfoRow('Temp', tempDir.path),
            _buildInfoRow('Size', _formatFileSize(tempSize)),
            const Divider(),
            _buildInfoRow('Total', _formatFileSize(appSize + tempSize)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Current path and actions
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          color: Colors.grey[200],
          child: Row(
            children: [
              if (_currentDirectory != null &&
                  _currentDirectory!.parent.path != _currentDirectory!.path)
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _loadDirectory(_currentDirectory!.parent),
                  tooltip: 'Go up',
                ),
              Expanded(
                child: Text(
                  _currentDirectory?.path ?? 'Loading...',
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.info_outline),
                onPressed: _showStorageInfo,
                tooltip: 'Storage info',
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  if (_currentDirectory != null) {
                    _loadDirectory(_currentDirectory!);
                  }
                },
                tooltip: 'Refresh',
              ),
            ],
          ),
        ),

        // File list
        Expanded(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _files.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.folder_open,
                            size: 64,
                            color: Colors.grey[400],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Empty directory',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _files.length,
                      itemBuilder: (context, index) {
                        final entity = _files[index];
                        final isDirectory = entity is Directory;
                        final name = _getFileName(entity.path);

                        return ListTile(
                          leading: Icon(
                            isDirectory ? Icons.folder : Icons.insert_drive_file,
                            color: isDirectory
                                ? Colors.blue
                                : Colors.grey[600],
                          ),
                          title: Text(name),
                          subtitle: !isDirectory
                              ? FutureBuilder<FileStat>(
                                  future: (entity as File).stat(),
                                  builder: (context, snapshot) {
                                    if (snapshot.hasData) {
                                      return Text(
                                        _formatFileSize(snapshot.data!.size),
                                        style: const TextStyle(fontSize: 12),
                                      );
                                    }
                                    return const Text('');
                                  },
                                )
                              : null,
                          trailing: const Icon(Icons.chevron_right),
                          onTap: () {
                            if (isDirectory) {
                              _loadDirectory(entity);
                            } else {
                              // Could implement file preview here
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('File: $name'),
                                  action: SnackBarAction(
                                    label: 'OK',
                                    onPressed: () {},
                                  ),
                                ),
                              );
                            }
                          },
                        );
                      },
                    ),
        ),
      ],
    );
  }
}

