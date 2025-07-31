import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_model.dart';

class NoticeRemoteDataSource {
  final http.Client client;

  NoticeRemoteDataSource(this.client);
  final Dio _dio = ApiClient.instance.dio;

  Future<List<NoticeModel>> fetchNotices(int lectureId) async {
    final response = await _dio.get('/students/lectures/$lectureId/notices');

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => NoticeModel.fromJson(e)).toList();
    } else {
      throw Exception('공지사항을 불러오지 못했습니다.');
    }
  }

  Future<List<NoticeModel>> fetchPinnedNotices(int lectureId) async {
    final response = await _dio.get(
      '/students/lectures/$lectureId/notices/pin',
    );

    if (response.statusCode == 200) {
      final List data = response.data['data'];
      return data.map((e) => NoticeModel.fromJson(e)).toList();
    } else {
      throw Exception('고정된 공지사항을 불러오지 못했습니다.');
    }
  }
}
