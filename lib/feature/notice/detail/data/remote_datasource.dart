import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/feature/notice/detail/data/model.dart';

class NoticeDetailRemoteDataSource {
  final http.Client client;
  
  NoticeDetailRemoteDataSource(this.client);
  
  Future<NoticeDetailModel> fetchNoticeDetail(int noticeId) async {
    final accessToken = await AuthStorage.getAccessToken();
    
    final response = await client.get(
      Uri.parse('${API.hostConnect}/students/notices/$noticeId'),
      headers: {'Authorization': 'Bearer $accessToken'}
    );

    if(response.statusCode == 200) {
      final data = json.decode(response.body);
      return NoticeDetailModel.fromJson(data);
    } else {
      throw Exception('공지를 불러오지 못했습니다.');
    }
  }
}