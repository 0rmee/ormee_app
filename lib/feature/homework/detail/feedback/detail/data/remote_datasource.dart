import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/model.dart';

class FeedbackDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<FeedbackDetailModel>> fetchFeedbackDetail(int submissionId) async {
    try {
      final response = await _dio.get('/students/homeworks/submissions/$submissionId/feedback');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((feedback) => FeedbackDetailModel.fromJson(feedback)).toList();
      } else {
        throw Exception('피드백 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('피드백 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}