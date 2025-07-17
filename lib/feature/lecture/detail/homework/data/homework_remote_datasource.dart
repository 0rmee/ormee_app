import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_model.dart';

class HomeworkRemoteDataSource {
  final http.Client client;

  HomeworkRemoteDataSource(this.client);

  Future<List<HomeworkModel>> fetchHomeworks(int lectureId) async {
    final response = await client.get(
      Uri.parse(
        'https://52.78.13.49.nip.io:8443/students/lectures/$lectureId/homeworks',
      ),
      headers: {
        'Authorization':
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMTIzIiwiYXV0aCI6IlJPTEVfVEVBQ0hFUiIsImV4cCI6MTc4MzY2Mjg1Mn0.0OAtQJXrPVMuGCednj-aXXGgmezJdzIvxVGzYqwndxs",
      }, //TODO: token 수정
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => HomeworkModel.fromJson(e)).toList();
    } else {
      throw Exception('숙제 정보를 불러오지 못했습니다.');
    }
  }
}
