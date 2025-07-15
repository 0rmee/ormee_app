import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/home/data/model.dart';

class LectureHomeRemoteDataSource {
  final http.Client client;

  LectureHomeRemoteDataSource(this.client);

  Future<List<LectureHome>> fetchLectures() async {
    final response = await client.get(
      Uri.parse('https://52.78.13.49.nip.io:8443/students/lectures'),
      headers: {
        'Authorization':
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJzdHVkZW50MyIsImF1dGgiOiJST0xFX1NUVURFTlQiLCJleHAiOjE3ODM2NjY4OTF9.m_Bb8CU6mYTcNP-Y15YPUgcz6VRnTplbwTxEs0fNqS0",
      }, //TODO: token 수정
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => LectureHome.fromJson(e)).toList();
    } else {
      throw Exception('강의 목록을 불러오지 못했습니다.');
    }
  }
}
