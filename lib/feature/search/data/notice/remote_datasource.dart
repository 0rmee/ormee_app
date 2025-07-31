import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/search/data/notice/model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NoticeRemoteDataSource {
  Future<List<Notice>> searchNotices(String keyword, int lectureId);
  Future<List<SearchHistory>> getSearchHistory();
  Future<void> saveSearchHistory(String keyword);
  Future<void> deleteSearchHistory(String keyword);
  Future<void> clearAllSearchHistory();
}

class NoticeRemoteDataSourceImpl implements NoticeRemoteDataSource {
  final Dio _dio = ApiClient.instance.dio;
  static const String searchHistoryKey = 'search_history';

  @override
  Future<List<Notice>> searchNotices(String keyword, int lectureId) async {
    try {
      final response = await _dio.get(
        '/students/lectures/$lectureId/notices/search',
        queryParameters: {'keyword': keyword},
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            // 필요 시 Authorization 헤더 추가
            // 'Authorization': 'Bearer $token',
          },
        ),
      );

      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final noticeResponse = NoticeSearchResponse.fromJson(jsonResponse);

        if (noticeResponse.status == 'success') {
          return noticeResponse.data;
        } else {
          throw Exception('API 응답 상태가 실패입니다: ${noticeResponse.status}');
        }
      } else {
        throw Exception('HTTP 에러: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('공지사항 검색 실패: $e');
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
        ..sort((a, b) => b.searchDate.compareTo(a.searchDate)); // 최신순 정렬
    } catch (e) {
      throw Exception('검색 기록 불러오기 실패: $e');
    }
  }

  @override
  Future<void> saveSearchHistory(String keyword) async {
    try {
      if (keyword.trim().isEmpty) return;

      final prefs = await SharedPreferences.getInstance();
      final historyJson = prefs.getStringList(searchHistoryKey) ?? [];

      // 기존 검색어 제거 (중복 방지)
      historyJson.removeWhere((item) {
        final history = SearchHistory.fromJson(json.decode(item));
        return history.keyword == keyword;
      });

      // 새 검색어 추가 (맨 앞에)
      final newHistory = SearchHistory(
        keyword: keyword,
        searchDate: DateTime.now(),
      );
      historyJson.insert(0, json.encode(newHistory.toJson()));

      // 최대 20개까지만 저장
      if (historyJson.length > 20) {
        historyJson.removeRange(20, historyJson.length);
      }

      await prefs.setStringList(searchHistoryKey, historyJson);
    } catch (e) {
      throw Exception('검색 기록 저장 실패: $e');
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
      throw Exception('검색 기록 삭제 실패: $e');
    }
  }

  @override
  Future<void> clearAllSearchHistory() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(searchHistoryKey);
    } catch (e) {
      throw Exception('전체 검색 기록 삭제 실패: $e');
    }
  }
}
