import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/homework/detail/data/model.dart';

class HomeworkDetailRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;

  Future<HomeworkDetailModel> fetchHomeworkDetail(int homeworkId) async {
    try {
      final response = await _dio.get('/students/homeworks/$homeworkId');

      if (response.statusCode == 200 && response.data != null) {
        return HomeworkDetailModel.fromJson(response.data);
      } else {
        throw Exception('숙제 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      throw Exception('숙제 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}
