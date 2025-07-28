import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_model.dart';

class HomeworkRemoteDataSource {
  final http.Client client;

  HomeworkRemoteDataSource(this.client);
  final Dio _dio = ApiClient.instance.dio;

  Future<List<HomeworkModel>> fetchHomeworks(int lectureId) async {
    final response = await _dio.get('/students/lectures/$lectureId/homeworks');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => HomeworkModel.fromJson(e)).toList();
    } else {
      throw Exception('숙제 정보를 불러오지 못했습니다.');
    }
  }
}
