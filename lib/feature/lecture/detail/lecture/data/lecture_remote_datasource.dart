import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_model.dart';

class LectureRemoteDataSource {
  final http.Client client;

  LectureRemoteDataSource(this.client);
  final Dio _dio = ApiClient.instance.dio;

  Future<LectureModel> fetchLectureDetail(int lectureId) async {
    final response = await _dio.get('/students/lectures/$lectureId');

    if (response.statusCode == 200) {
      final data = response.data['data'];
      return LectureModel.fromJson(data);
    } else {
      throw Exception('강의 정보를 불러오지 못했습니다.');
    }
  }
}
