import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_model.dart';

class QuizRemoteDataSource {
  final http.Client client;

  QuizRemoteDataSource(this.client);
  final Dio _dio = ApiClient.instance.dio;

  Future<List<QuizModel>> fetchQuizzes(int lectureId) async {
    final response = await _dio.get('/students/lectures/$lectureId/quizzes');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => QuizModel.fromJson(e)).toList();
    } else {
      print('error: ${response.statusCode}');
      throw Exception('퀴즈 정보를 불러오지 못했습니다.');
    }
  }
}
