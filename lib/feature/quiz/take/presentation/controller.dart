import 'dart:async';

import 'package:get/get.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/feature/quiz/detail/data/repository.dart';

mixin QuizTimerMixin on GetxController {
  Timer? _timer;
  var remainingTime = '00:00:00'.obs;
  var isTimeUp = false.obs;

  void startTimer(QuizDetail quizDetail) {
    _timer?.cancel();
    final now = DateTime.now();
    final dueTime = quizDetail.dueDateTime;

    DateTime? effectiveEndTime;

    if (quizDetail.hasTimeLimit) {
      // 시간 제한이 있는 경우: 현재 시간 + 시간 제한과 마감 시간 중 더 이른 시간
      final timeLimitEndTime = now.add(quizDetail.timeLimitDuration);
      effectiveEndTime = dueTime.isBefore(timeLimitEndTime)
          ? dueTime
          : timeLimitEndTime;
    } else {
      // 시간 제한이 없는 경우: 마감 1시간 전부터만 타이머 표시
      final oneHourBeforeDue = dueTime.subtract(Duration(hours: 1));
      if (now.isBefore(oneHourBeforeDue)) {
        // 아직 1시간 전이 아니면 타이머 시작 안함
        remainingTime.value = '';
        // 🔔 1시간 전이 되는 시점에 타이머 시작 예약
        final delay = oneHourBeforeDue.difference(now);
        Future.delayed(delay, () {
          if (!isClosed && quizDetail.dueDateTime.isAfter(DateTime.now())) {
            startTimer(quizDetail); // 다시 타이머 시작
          }
        });
        return;
      }
      effectiveEndTime = dueTime;
    }

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      final currentTime = DateTime.now();
      final difference = effectiveEndTime!.difference(currentTime);

      if (difference.isNegative) {
        timer.cancel();
        isTimeUp.value = true;
        remainingTime.value = '00:00:00';
        return;
      }

      final hours = difference.inHours.toString().padLeft(2, '0');
      final minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
      final seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
      remainingTime.value = '$hours:$minutes:$seconds 남음';
    });
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}

class QuizController extends GetxController with QuizTimerMixin {
  final QuizRepository _repository = QuizRepository();

  var isLoading = false.obs;
  var quiz = Rx<QuizResponse?>(null);
  var error = Rx<String?>(null);
  var answers = <int, String>{}.obs; // problemId: answer 형태로 저장
  //var hasSubmitted = false.obs;

  QuizDetail? get quizDetail => quiz.value?.data.detailInfo;
  QuizTake? get quizTake => quiz.value?.data.takeInfo;
  List<Problem> get problems => quizTake?.problems ?? [];

  Future<void> fetchQuiz(int quizId) async {
    isLoading(true);
    error(null);

    try {
      final response = await _repository.getQuiz(quizId);
      quiz.value = response;

      //타이머 시작 (퀴즈 정보가 로드된 후)
      if (quizDetail != null && !quizDetail!.submitted) {
        startTimer(quizDetail!);
      }
    } on QuizException catch (e) {
      error(e.message);
      print("오류");
    } catch (e) {
      error('퀴즈 정보를 불러오는데 실패했습니다.');
      print("오류");
    } finally {
      isLoading(false);
    }
  }

  Future<void> submitQuiz(int quizId) async {
    //if (hasSubmitted.value) return;

    if (answers.isEmpty) {
      return;
    }

    try {
      isLoading(true);
      await _repository.submitQuiz(quizId: quizId, answers: answers);
      //hasSubmitted.value = true;

      // 제출 성공시 타이머 중지
      _timer?.cancel();

      print("성공");
    } on QuizException catch (e) {
      //hasSubmitted.value = false;
      print("오류");
    } catch (e) {
      //hasSubmitted.value = false;
      print("오류");
    } finally {
      isLoading(false);
    }
  }

  // 답안 저장
  void saveAnswer(int problemId, String answer) {
    answers[problemId] = answer;
  }

  // 특정 문제의 답안 가져오기
  String? getAnswer(int problemId) {
    return answers[problemId];
  }

  // 답안 완료율 계산
  double get completionRate {
    if (problems.isEmpty) return 0.0;
    return (answers.length / problems.length) * 100;
  }

  // 완료된 문제 수
  int get completedCount => answers.length;

  // 전체 문제 수
  int get totalCount => problems.length;

  // 퀴즈 상태 확인
  QuizStatus get quizStatus {
    if (quizDetail == null) return QuizStatus.notStarted;

    return QuizUtils.getQuizStatus(
      detail: quizDetail!,
      hasSubmissions: answers.isNotEmpty,
      isSubmitted: quizDetail!.submitted,
    );
  }
}
