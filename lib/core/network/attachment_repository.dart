import 'dart:io';

import 'package:dio/dio.dart';
import 'package:ormee_app/core/constants/api.dart';

class AttachmentRepository {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: '${API.hostConnect}',
      connectTimeout: Duration(seconds: 10),
      receiveTimeout: Duration(seconds: 10),
    ),
  );

  Future<int> uploadAttachment({
    required File file,
    required String type,
    // 타입 종류: QUIZ, NOTICE, HOMEWORK, HOMEWORK_SUBMIT, QUESTION, ANSWER, TEACHER_IMAGE
  }) async {
    try {
      final fileName = file.path.split('/').last;

      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(file.path, filename: fileName),
        'type': type,
      });

      final response = await _dio.post('/attachment', data: formData);

      if (response.statusCode == 200 && response.data['status'] == 'success') {
        return response.data['data']; // 파일 ID 반환
      } else {
        throw Exception('파일 업로드 실패: ${response.data}');
      }
    } catch (e) {
      print('Attachment upload error: $e');
      rethrow;
    }
  }
}
