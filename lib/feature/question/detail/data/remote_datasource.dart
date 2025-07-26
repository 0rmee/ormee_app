import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/question/detail/data/model.dart';

class QuestionDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;
  
  Future<QuestionDetailModel> fetchQuestionDetail(int questionId) async {
    try {
      final response = await _dio.get('/students/questions/$questionId');

      if(response.statusCode == 200 && response.data != null) {
        return QuestionDetailModel.fromJson(response.data);
      } else {
        throw Exception('질문 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('질문 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}