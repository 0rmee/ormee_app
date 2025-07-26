import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/memo/data/model.dart';

class MemoRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<MemoModel> fetchMemoDetail(int memoId) async {
    try {
      final response = await _dio.get('/students/memos/$memoId');

      if (response.statusCode == 200 && response.data != null) {
        return MemoModel.fromJson(response.data['data']);
      } else {
        throw Exception('쪽지 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('쪽지 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }

  Future<void> postMemo(int memoId, MemoModel request) async {
    try {
      final response = await _dio.post(
        '/students/memos/$memoId',
        data: request,
      );

      if (response.statusCode != 200) {
        throw Exception('쪽지 제출에 실패했습니다. 잠시 후 다시 시도해주세요.');
      }
    } catch (e) {
      throw Exception('쪽지 제출 요청 중 오류가 발생했습니다.');
    }
  }

  Future<List<MemoModel>> fetchMemoList(int lectureId) async {
    try {
      final response = await _dio.get('/students/lectures/$lectureId/memos');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> dataList = response.data['data'] ?? [];
        return dataList.map((json) => MemoModel.fromJson(json)).toList();
      } else {
        throw Exception('쪽지 목록 조회에 실패했습니다. 잠시 후 다시 시도해주세요.');
      }
    } catch (e) {
      throw Exception('쪽지 목록 조회 요청 중 오류가 발생했습니다.');
    }
  }
}
