import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/homework/detail/data/model.dart';

import 'package:http/http.dart' as http;

class HomeworkDetailRemoteDataSource {
  // final Dio _dio = ApiClient.instance.dio;
  //
  // Future<HomeworkDetailModel> fetchHomeworkDetail(int homeworkId) async {
  //   try {
  //     final response = await _dio.get('/students/homeworks/$homeworkId');
  //
  //     if (response.statusCode == 200 && response.data != null) {
  //       return HomeworkDetailModel.fromJson(response.data);
  //     } else {
  //       throw Exception('숙제 데이터를 불러올 수 없습니다.');
  //     }
  //   } catch (e) {
  //     throw Exception('숙제 데이터를 불러오는 중 오류가 발생했습니다.');
  //   }
  // } 인터셉터 문제 해결되면 수정
  final http.Client client;

  HomeworkDetailRemoteDataSource(this.client);

  Future<HomeworkDetailModel> fetchHomeworkDetail(int homeworkId) async {
    final accessToken = await AuthStorage.getAccessToken();
      try {
        final response = await client.get(
            Uri.parse('${API.hostConnect}/students/homeworks/$homeworkId'),
            headers: {
              'Authorization': 'Bearer $accessToken',
              'Content-Type': 'application/json',
            });

        if (response.statusCode == 200 && response.body != null) {
          final data = json.decode(response.body);
          return HomeworkDetailModel.fromJson(data);
        } else {
          throw Exception('숙제 데이터를 불러올 수 없습니다.');
        }
      } catch (e) {
        throw Exception('숙제 데이터를 불러오는 중 오류가 발생했습니다.');
      }
  }
}
