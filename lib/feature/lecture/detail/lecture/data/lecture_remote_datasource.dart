import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_model.dart';

class LectureRemoteDataSource {
  final http.Client client;

  LectureRemoteDataSource(this.client);

  Future<LectureModel> fetchLectureDetail(int lectureId) async {
    final accessToken = await AuthStorage.getAccessToken();
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/lectures/$lectureId'),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'];
      print('data: $data');
      return LectureModel.fromJson(data);
    } else {
      throw Exception('강의 정보를 불러오지 못했습니다.');
    }
  }
}
