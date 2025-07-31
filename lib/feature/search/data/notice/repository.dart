import 'package:ormee_app/feature/search/data/notice/model.dart';
import 'package:ormee_app/feature/search/data/notice/remote_datasource.dart';

abstract class NoticeSearchRepository {
  Future<List<Notice>> searchNotices(String keyword, int lectureId);
  Future<List<SearchHistory>> getSearchHistory();
  Future<void> saveSearchHistory(String keyword);
  Future<void> deleteSearchHistory(String keyword);
  Future<void> clearAllSearchHistory();
}

class NoticeSearchRepositoryImpl implements NoticeSearchRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeSearchRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Notice>> searchNotices(String keyword, int lectureId) async {
    try {
      // 검색 수행
      final notices = await remoteDataSource.searchNotices(keyword, lectureId);

      // 검색이 성공했을 때만 검색 기록 저장
      if (notices.isNotEmpty || keyword.trim().isNotEmpty) {
        await remoteDataSource.saveSearchHistory(keyword);
      }

      return notices;
    } catch (e) {
      // 검색 실패 시에도 검색어는 저장 (사용자가 검색을 시도했기 때문)
      if (keyword.trim().isNotEmpty) {
        try {
          await remoteDataSource.saveSearchHistory(keyword);
        } catch (_) {
          // 검색 기록 저장 실패는 무시 (주요 기능이 아니므로)
        }
      }
      rethrow;
    }
  }

  @override
  Future<List<SearchHistory>> getSearchHistory() async {
    try {
      return await remoteDataSource.getSearchHistory();
    } catch (e) {
      // 검색 기록 불러오기 실패 시 빈 리스트 반환
      return [];
    }
  }

  @override
  Future<void> saveSearchHistory(String keyword) async {
    try {
      await remoteDataSource.saveSearchHistory(keyword);
    } catch (e) {
      // 검색 기록 저장 실패는 사용자에게 에러로 표시하지 않음
      print('검색 기록 저장 실패: $e');
    }
  }

  @override
  Future<void> deleteSearchHistory(String keyword) async {
    try {
      await remoteDataSource.deleteSearchHistory(keyword);
    } catch (e) {
      throw Exception('검색 기록 삭제에 실패했습니다');
    }
  }

  @override
  Future<void> clearAllSearchHistory() async {
    try {
      await remoteDataSource.clearAllSearchHistory();
    } catch (e) {
      throw Exception('전체 검색 기록 삭제에 실패했습니다');
    }
  }
}
