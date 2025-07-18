import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/question/create/data/model.dart';

class QuestionCreateRemoteDataSource {
  final http.Client client;

  QuestionCreateRemoteDataSource(this.client);

  Future<void> postQuestion(int lectureId, QuestionRequest request) async {
    final response = await client.post(
      Uri.parse(
        'https://52.78.13.49.nip.io:8443/students/lectures/$lectureId/questions',
      ),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHVkZW50MyIsImF1dGgiOiJST0xFX1NUVURFTlQiLCJleHAiOjE3ODM2NjY4OTF9.m_Bb8CU6mYTcNP-Y15YPUgcz6VRnTplbwTxEs0fNqS0",
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception('질문 등록 실패: ${response.body}');
    }
  }
}
