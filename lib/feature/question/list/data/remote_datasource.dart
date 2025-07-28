import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/question/list/data/model.dart';

class QuestionListRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<List<QuestionListModel>> fetchQuestionList(int lectureId) async {
    try {
      final response = await _dio.get('/students/lectures/$lectureId/questions');

      if (response.statusCode == 200 && response.data != null) {
        final List<dynamic> data = response.data['data'];
        return data.map((question) => QuestionListModel.fromJson(question)).toList();
      } else {
        throw Exception('질문 목록 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('질문 목록 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}