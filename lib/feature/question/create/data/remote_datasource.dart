import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/question/create/data/model.dart';

class QuestionCreateRemoteDataSource {
  final http.Client client;

  QuestionCreateRemoteDataSource(this.client);

  Future<void> postQuestion(int lectureId, QuestionRequest request) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.post(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId/questions'),
      headers: {'Authorization': 'Bearer $accessToken'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('질문 등록 실패: ${response.body}');
    }
  }
}
