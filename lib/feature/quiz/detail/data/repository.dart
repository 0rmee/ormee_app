import 'package:dio/dio.dart';
import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';

class QuizRepository {
  final Dio _dio = ApiClient.instance.dio;

  /// 퀴즈 상세 정보 조회 (detail + take 페이지 모두 사용)
  Future<QuizResponse> getQuiz(int quizId) async {
    try {
      final response = await _dio.get('/students/quizzes/$quizId');
      return QuizResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw QuizException('퀴즈 정보를 가져오는데 실패했습니다: $e');
    }
  }

  /// 퀴즈 전체 제출
  Future<void> submitQuiz({
    required int quizId,
    required Map<int, String> answers, // problemId: answer
  }) async {
    try {
      final submissions = answers.entries
          .map(
            (entry) =>
                ProblemSubmission(problemId: entry.key, content: entry.value),
          )
          .toList();

      await _dio.post(
        '/students/quizzes',
        data: submissions.map((s) => s.toJson()).toList(),
      );
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        throw QuizException('이미 제출된 퀴즈입니다.');
      }
      throw _handleDioException(e);
    } catch (e) {
      throw QuizException('퀴즈 제출에 실패했습니다: $e');
    }
  }

  /// 퀴즈 결과 조회
  Future<QuizResultResponse> getQuizResult(int quizId) async {
    try {
      final response = await _dio.get('/students/quizzes/$quizId/result');
      return QuizResultResponse.fromJson(response.data);
    } on DioException catch (e) {
      throw _handleDioException(e);
    } catch (e) {
      throw QuizException('퀴즈 결과를 가져오는데 실패했습니다: $e');
    }
  }

  /// Dio 예외 처리
  QuizException _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return QuizException('네트워크 연결 시간이 초과되었습니다.');

      case DioExceptionType.badResponse:
        final statusCode = e.response?.statusCode;
        final message = e.response?.data?['message'] ?? '서버 오류가 발생했습니다.';

        switch (statusCode) {
          case 400:
            return QuizException('잘못된 요청입니다: $message');
          case 401:
            return QuizException('인증이 필요합니다.');
          case 403:
            return QuizException('이미 제출된 퀴즈입니다.');
          case 404:
            return QuizException('퀴즈를 찾을 수 없습니다.');
          case 409:
            return QuizException('이미 제출된 퀴즈입니다.');
          case 422:
            return QuizException('입력 데이터가 올바르지 않습니다: $message');
          case 500:
            return QuizException('서버 내부 오류가 발생했습니다.');
          default:
            return QuizException('서버 오류가 발생했습니다: $message');
        }

      case DioExceptionType.cancel:
        return QuizException('요청이 취소되었습니다.');

      case DioExceptionType.connectionError:
        return QuizException('네트워크 연결을 확인해주세요.');

      case DioExceptionType.badCertificate:
        return QuizException('보안 인증서 오류가 발생했습니다.');

      case DioExceptionType.unknown:
      default:
        return QuizException('알 수 없는 오류가 발생했습니다: ${e.message}');
    }
  }
}

/// 퀴즈 관련 예외 클래스
class QuizException implements Exception {
  final String message;

  QuizException(this.message);

  @override
  String toString() => 'QuizException: $message';
}

/// 퀴즈 상태 열거형
enum QuizStatus {
  notStarted, // 시작 전
  inProgress, // 진행 중
  submitted, // 제출 완료
  expired, // 기간 만료
}

/// 퀴즈 관련 유틸리티 클래스
class QuizUtils {
  /// 퀴즈 상태 판단
  static QuizStatus getQuizStatus({
    required QuizDetail detail,
    required bool hasSubmissions,
    required bool isSubmitted,
  }) {
    final now = DateTime.now();

    if (now.isBefore(detail.openDateTime)) {
      return QuizStatus.notStarted;
    }

    if (detail.submitted) {
      return QuizStatus.submitted;
    }

    if (now.isAfter(detail.dueDateTime)) {
      return QuizStatus.expired;
    }

    return QuizStatus.inProgress;
  }

  /// 남은 시간 포맷팅
  static String formatRemainingTime(Duration duration) {
    if (duration.isNegative) return '마감됨';

    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}일 ${hours}시간 ${minutes}분';
    } else if (hours > 0) {
      return '${hours}시간 ${minutes}분';
    } else {
      return '${minutes}분';
    }
  }

  /// 시간 제한 포맷팅
  static String formatTimeLimit(int minutes) {
    if (minutes <= 0) return '시간 제한 없음';

    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;

    if (hours > 0) {
      return remainingMinutes > 0
          ? '${hours}시간 ${remainingMinutes}분'
          : '${hours}시간';
    } else {
      return '${remainingMinutes}분';
    }
  }
}
