import 'dart:io';
import 'package:path_provider/path_provider.dart';

class CacheManager {
  static Future<Directory> getCacheDirectory() async {
    return await getTemporaryDirectory();
  }

  static Future<Directory> getAppDocumentsDirectory() async {
    return await getApplicationDocumentsDirectory();
  }

  static Future<String> getCachePath() async {
    final directory = await getCacheDirectory();
    return directory.path;
  }

  static Future<String> getAppDocumentsPath() async {
    final directory = await getAppDocumentsDirectory();
    return directory.path;
  }

  static Future<File> getCachedFile(String filename) async {
    final directory = await getCacheDirectory();
    return File('${directory.path}/$filename');
  }

  static Future<void> clearCache() async {
    final directory = await getCacheDirectory();
    if (await directory.exists()) {
      await directory.delete(recursive: true);
      await directory.create();
    }
  }

  static Future<int> getCacheSize() async {
    final directory = await getCacheDirectory();
    int totalSize = 0;

    if (await directory.exists()) {
      await for (var entity in directory.list(recursive: true, followLinks: false)) {
        if (entity is File) {
          totalSize += await entity.length();
        }
      }
    }

    return totalSize;
  }

  static String formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(2)} KB';
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(2)} GB';
  }
}

