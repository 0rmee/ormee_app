import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/question/detail/answer/data/model.dart';

class AnswerDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<AnswerDetailModel> fetchAnswerDetail(int questionId) async {
    try {
      final response = await _dio.get('/students/questions/$questionId/answers');

      if(response.statusCode == 200 && response.data != null) {
        return AnswerDetailModel.fromJson(response.data);
      } else {
        throw Exception('답변 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('답변 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}