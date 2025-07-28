import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';

class FcmToken {
  final Dio _dio = ApiClient.instance.dio;

  Future<void> sendToken(String token) async {
    try {
      await _dio.post('/students/device', data: {'deviceToken': token});
      return;
    } on DioException catch (e) {
      if (e.response?.statusCode == 400) {
        throw Exception('Invalid device token format');
      } else if (e.response?.statusCode == 401) {
        throw Exception('Unauthorized access');
      } else if (e.response?.statusCode == 500) {
        throw Exception('Server error occurred');
      }
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}
