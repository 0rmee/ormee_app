import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_model.dart';

class NoticeRemoteDataSource {
  final http.Client client;

  NoticeRemoteDataSource(this.client);

  Future<List<NoticeModel>> fetchNotices(int lectureId) async {
    final response = await client.get(
      Uri.parse(
        'https://52.78.13.49.nip.io:8443/students/lectures/$lectureId/notices',
      ),
      headers: {'Content-Type': 'application/json'}, //TODO: token 수정
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body)['data'] as List;
      return data.map((e) => NoticeModel.fromJson(e)).toList();
    } else {
      throw Exception('공지사항을 불러오지 못했습니다.');
    }
  }
}
