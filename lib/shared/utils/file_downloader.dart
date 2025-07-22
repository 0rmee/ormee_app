import 'dart:io';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static Future<void> downloadFile(String url, {required String fileName}) async {
    final directory = await _getDownloadDirectory();
    final savePath = directory.path;

    await FlutterDownloader.enqueue(
        url: url,
        fileName: fileName,
        savedDir: savePath,
        showNotification: true,
        openFileFromNotification: true
    );
  }

  static Future<Directory> _getDownloadDirectory() async {
    if (Platform.isAndroid) {
      final dir = await getExternalStorageDirectory();
      if (dir != null) return dir;
    }
    return await getApplicationDocumentsDirectory();
  }
}