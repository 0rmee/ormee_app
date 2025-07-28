import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/question/create/data/model.dart';

class QuestionCreateRemoteDataSource {
  final http.Client client;

  QuestionCreateRemoteDataSource(this.client);

  final Dio _dio = ApiClient.instance.dio;

  Future<void> postQuestion(int lectureId, QuestionRequest request) async {
    final response = await _dio.post(
      '/students/lectures/$lectureId/questions',
      data: request,
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('질문 등록 실패: ${response.data}');
    }
  }
}
