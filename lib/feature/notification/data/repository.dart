import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/notification/data/model.dart';

class NotificationRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 공지 알림 목록 가져오기
  Future<List<NotificationModel>> fetchNotifications({
    String type = '과제',
  }) async {
    try {
      final res = await _dio.get(
        '/students/notifications',
        queryParameters: {'type': type},
      );

      if (res.statusCode == 200 && res.data != null) {
        final response = NotificationResponse.fromJson(res.data);
        return response.notifications;
      } else {
        throw Exception('Failed to load notifications: ${res.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  /// 공지 개별 삭제하기
  Future<bool> deleteNotification(int notificationId) async {
    try {
      final res = await _dio.delete('/students/notifications/$notificationId');

      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete notification: ${res.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }

  /// 공지 개별 읽기
  Future<bool> readNotification(int notificationId) async {
    try {
      final res = await _dio.put('/students/notifications/$notificationId');

      if (res.statusCode == 200 || res.statusCode == 204) {
        return true;
      } else {
        throw Exception('Failed to delete notification: ${res.statusCode}');
      }
    } on DioException catch (e) {
      print('DioException: ${e.message}');
      rethrow;
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
}
