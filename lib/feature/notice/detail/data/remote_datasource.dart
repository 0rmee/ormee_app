import 'package:dio/dio.dart';
import 'package:ormee_app/feature/notice/detail/data/model.dart';
import 'package:ormee_app/core/network/api_client.dart';

class NoticeDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<NoticeDetailModel> fetchNoticeDetail(int noticeId) async {
    try {
      final response = await _dio.get('/students/notices/$noticeId');

      if (response.statusCode == 200 && response.data != null) {
        return NoticeDetailModel.fromJson(response.data);
      } else {
        throw Exception('공지 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('공지 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }

  Future<void> likeNotice(int noticeId) async {
    try {
      final response = await _dio.put('/students/notices/$noticeId/like');

      if (response.statusCode != 200) {
        throw Exception('공지 좋아요에 실패했습니다. 잠시 후 다시 시도해주세요.');
      }
    } catch (e) {
      throw Exception('공지 좋아요 요청 중 오류가 발생했습니다.');
    }
  }

  Future<void> unlikeNotice(int noticeId) async {
    try {
      final response = await _dio.put('/students/notices/$noticeId/unlike');

      if (response.statusCode != 200) {
        throw Exception('공지 좋아요 취소에 실패했습니다. 잠시 후 다시 시도해주세요.');
      }
    } catch (e) {
      throw Exception('공지 좋아요 취소 요청 중 오류가 발생했습니다.');
    }
  }
}