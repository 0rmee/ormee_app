import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_model.dart';

class HomeworkRemoteDataSource {
  final http.Client client;

  HomeworkRemoteDataSource(this.client);

  Future<List<HomeworkModel>> fetchHomeworks(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId/homeworks'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => HomeworkModel.fromJson(e)).toList();
    } else {
      throw Exception('숙제 정보를 불러오지 못했습니다.');
    }
  }
}
