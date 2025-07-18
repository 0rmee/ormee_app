import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_model.dart';

class QuizRemoteDataSource {
  final http.Client client;

  QuizRemoteDataSource(this.client);

  Future<List<QuizModel>> fetchQuizzes(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId/quizzes'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => QuizModel.fromJson(e)).toList();
    } else {
      print('error: ${response.statusCode}');
      throw Exception('퀴즈 정보를 불러오지 못했습니다.');
    }
  }
}
