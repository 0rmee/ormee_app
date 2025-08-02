import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/mypage/history/data/model.dart';

class LectureHistoryRemoteDataSource {
  final http.Client client;

  LectureHistoryRemoteDataSource(this.client);

  final Dio _dio = ApiClient.instance.dio;

  Future<LectureHistoryData> fetchLectureHistory() async {
    final response = await _dio.get('/students/lectures/history');

    if (response.statusCode == 200) {
      final responseData = LectureHistoryResponse.fromJson(response.data);
      if (responseData.status == 'success') {
        return responseData.data;
      } else {
        throw Exception('수강내역을 불러오지 못했습니다.');
      }
    } else {
      throw Exception('수강내역을 불러오지 못했습니다.');
    }
  }
}
