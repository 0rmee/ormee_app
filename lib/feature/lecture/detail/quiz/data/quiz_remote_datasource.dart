import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_model.dart';

class QuizRemoteDataSource {
  final http.Client client;

  QuizRemoteDataSource(this.client);

  Future<List<QuizModel>> fetchQuizzes(int lectureId) async {
    final response = await client.get(
      Uri.parse(
        'https://52.78.13.49.nip.io:8443/students/lectures/$lectureId/quizzes',
      ),
      headers: {
        'Authorization':
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMTIzIiwiYXV0aCI6IlJPTEVfVEVBQ0hFUiIsImV4cCI6MTc4MzY2Mjg1Mn0.0OAtQJXrPVMuGCednj-aXXGgmezJdzIvxVGzYqwndxs",
      }, //TODO: token 수정
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
