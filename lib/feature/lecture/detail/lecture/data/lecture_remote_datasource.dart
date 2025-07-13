import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_model.dart';

class LectureRemoteDataSource {
  final http.Client client;

  LectureRemoteDataSource(this.client);

  Future<LectureModel> fetchLectureDetail(int lectureId) async {
    final response = await client.get(
      Uri.parse('https://52.78.13.49.nip.io:8443/students/lectures/$lectureId'),
      headers: {
        'Authorization':
            "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiJ0ZWFjaGVyMTIzIiwiYXV0aCI6IlJPTEVfVEVBQ0hFUiIsImV4cCI6MTc4MzY2Mjg1Mn0.0OAtQJXrPVMuGCednj-aXXGgmezJdzIvxVGzYqwndxs",
      }, //TODO: token 수정
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
