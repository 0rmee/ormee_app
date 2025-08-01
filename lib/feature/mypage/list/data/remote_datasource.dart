import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';

class MyPageProfileRemoteDatasource {
  final Dio _dio = ApiClient.instance.dio;

  Future<String> fetchProfile() async {
    try {
      final response = await _dio.get('/students/profile');

      if (response.statusCode == 200 && response.data != null) {
        return response.data['data'] as String;
      } else {
        throw Exception('프로필 데이터를 불러올 수 없습니다.');
      }
    } catch (e) {
      print(e.toString());
      throw Exception('프로필 데이터를 불러오는 중 오류가 발생했습니다.');
    }
  }
}