import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/lecture/home/data/model.dart';

class LectureHomeRemoteDataSource {
  final http.Client client;

  LectureHomeRemoteDataSource(this.client);

  Future<List<LectureHome>> fetchLectures() async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/lectures'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final List data = json.decode(response.body)['data'];
      return data.map((e) => LectureHome.fromJson(e)).toList();
    } else {
      throw Exception('강의 목록을 불러오지 못했습니다.');
    }
  }

  Future<void> leaveLecture(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.delete(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('강의실 퇴장 실패');
    }
  }

  Future<void> enterLecture(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.post(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode != 200) {
      throw Exception('강의실 입장 실패');
    }
  }

  Future<LectureHome> fetchLectureById(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      return LectureHome.fromJson(data);
    } else {
      throw Exception('강의 정보를 불러오지 못했습니다.');
    }
  }
}
