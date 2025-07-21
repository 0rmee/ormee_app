import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';

class FileDownloader {
  static Future<void> downloadFile(String url, {required String fileName}) async {
    final directory = await getExternalStorageDirectory();
    final savePath = directory?.path ?? '';

    if(savePath.isEmpty) {
      throw Exception('저장 경로를 찾을 수 없습니다.');
    }

    await FlutterDownloader.enqueue(
        url: url,
        fileName: fileName,
        savedDir: savePath,
        showNotification: true,
        openFileFromNotification: true
    );
  }
}