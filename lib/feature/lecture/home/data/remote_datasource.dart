import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/lecture/home/data/model.dart';

class LectureHomeRemoteDataSource {
  final http.Client client;

  LectureHomeRemoteDataSource(this.client);

  final Dio _dio = ApiClient.instance.dio;

  Future<List<LectureHome>> fetchLectures() async {
    final response = await _dio.get('/students/lectures');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => LectureHome.fromJson(e)).toList();
    } else {
      throw Exception('강의 목록을 불러오지 못했습니다.');
    }
  }

  Future<void> leaveLecture(int lectureId) async {
    final response = await _dio.delete('/students/lectures/$lectureId');

    if (response.statusCode != 200) {
      throw Exception('강의실 퇴장 실패');
    }
  }

  Future<void> enterLecture(int lectureId) async {
    final response = await _dio.post('/students/lectures/$lectureId');

    if (response.statusCode != 200) {
      throw Exception('강의실 입장 실패');
    }
  }

  Future<LectureHome> fetchLectureById(int lectureId) async {
    final response = await _dio.get('/students/lectures/$lectureId');

    if (response.statusCode == 200) {
      final data = response.data['data'];
      return LectureHome.fromJson(data);
    } else {
      throw Exception('강의 정보를 불러오지 못했습니다.');
    }
  }
}
