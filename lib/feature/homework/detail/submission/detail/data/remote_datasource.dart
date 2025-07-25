import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/data/model.dart';

class HomeworkSubmissionDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<HomeworkSubmissionDetailModel> fetchHomeworkSubmissionDetail(int homeworkId) async {
    try {
      final response = await _dio.get('/students/homeworks/$homeworkId/submissions');

      if (response.statusCode == 200 && response.data != null) {
        return HomeworkSubmissionDetailModel.fromJson(response.data);
      } else {
        throw Exception('숙제 제출 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('숙제 제출 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}
