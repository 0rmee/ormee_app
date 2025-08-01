import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/search/data/notification/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NotificationRemoteDataSource {
  Future<List<Notification>> searchNotifications(String keyword);
  Future<List<SearchHistory>> getSearchHistory();
  Future<void> saveSearchHistory(String keyword);
  Future<void> deleteSearchHistory(String keyword);
  Future<void> clearAllSearchHistory();
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;
  static const String searchHistoryKey = 'notification_search_history';

  @override
  Future<List<Notification>> searchNotifications(String keyword) async {
    try {
      final response = await _dio.get(
        '/students/notifications/search',
        queryParameters: {'keyword': keyword},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final result = NotificationSearchResponse.fromJson(jsonResponse);

        if (result.status == 'success') {
          return result.data;
        } else {
          throw Exception('API 응답 상태 실패: ${result.status}');
        }
      } else {
        throw Exception('HTTP 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('알림 검색 실패: $e');
    }
  }

  @override
  Future<List<SearchHistory>> getSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(searchHistoryKey) ?? [];

      return historyJson
          .map((item) => SearchHistory.fromJson(json.decode(item)))
          .toList()
        ..sort((a, b) => b.searchDate.compareTo(a.searchDate));
    } catch (e) {
      throw Exception('알림 검색 기록 불러오기 실패: $e');
    }
  }

  @override
  Future<void> saveSearchHistory(String keyword) async {
    try {
      if (keyword.trim().isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(searchHistoryKey) ?? [];

      historyJson.removeWhere((item) {
        final history = SearchHistory.fromJson(json.decode(item));
        return history.keyword == keyword;
      });

      final newHistory = SearchHistory(
        keyword: keyword,
        searchDate: DateTime.now(),
      );
      historyJson.insert(0, json.encode(newHistory.toJson()));

      if (historyJson.length > 20) {
        historyJson.removeRange(20, historyJson.length);
      }

      await prefs.setStringList(searchHistoryKey, historyJson);
    } catch (e) {
      throw Exception('알림 검색 기록 저장 실패: $e');
    }
  }

  @override
  Future<void> deleteSearchHistory(String keyword) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(searchHistoryKey) ?? [];

      historyJson.removeWhere((item) {
        final history = SearchHistory.fromJson(json.decode(item));
        return history.keyword == keyword;
      });

      await prefs.setStringList(searchHistoryKey, historyJson);
    } catch (e) {
      throw Exception('알림 검색 기록 삭제 실패: $e');
    }
  }

  @override
  Future<void> clearAllSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(searchHistoryKey);
    } catch (e) {
      throw Exception('전체 알림 검색 기록 삭제 실패: $e');
    }
  }
}
