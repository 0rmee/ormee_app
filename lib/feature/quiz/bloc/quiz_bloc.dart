// quiz_bloc.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/quiz/bloc/quiz_state.dart';
import 'package:ormee_app/feature/quiz/detail/data/repository.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository _repository;

  QuizBloc(QuizRepository repository)
    : _repository = repository,
      super(const QuizInitial()) {
    on<LoadQuiz>(_onLoadQuiz);
    on<UpdateAnswer>(_onUpdateAnswer);
    on<SubmitQuiz>(_onSubmitQuiz);
    on<LoadQuizResult>(_onLoadQuizResult);
    on<ResetQuiz>(_onResetQuiz);
  }

  Future<void> _onLoadQuiz(LoadQuiz event, Emitter<QuizState> emit) async {
    emit(const QuizLoading());

    try {
      final quizResponse = await _repository.getQuiz(event.quizId);
      final detail = quizResponse.data.detailInfo;

      // 기존 제출된 답안이 있다면 초기화
      final initialAnswers = <int, String>{};
      for (final problem in quizResponse.data.problems) {
        if (problem.submission != null && problem.submission!.isNotEmpty) {
          initialAnswers[problem.id] = problem.submission!;
        }
      }

      // 퀴즈 상태 판단
      final status = QuizUtils.getQuizStatus(
        detail: detail,
        hasSubmissions: initialAnswers.isNotEmpty,
        isSubmitted: quizResponse.data.problems.any(
          (p) => p.submission != null && p.submission!.isNotEmpty,
        ),
      );

      emit(
        QuizLoaded(
          quizResponse: quizResponse,
          answers: initialAnswers,
          status: status,
        ),
      );
    } on QuizException catch (e) {
      emit(QuizError(message: e.message));
    } catch (e) {
      emit(QuizError(message: '퀴즈를 불러오는데 실패했습니다: $e'));
    }
  }

  void _onUpdateAnswer(UpdateAnswer event, Emitter<QuizState> emit) {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      // 이미 제출된 퀴즈라면 답안 수정 불가
      if (currentState.isSubmitted) {
        return;
      }

      final updatedAnswers = Map<int, String>.from(currentState.answers);

      if (event.answer.isEmpty) {
        updatedAnswers.remove(event.problemId);
      } else {
        updatedAnswers[event.problemId] = event.answer;
      }

      emit(currentState.copyWith(answers: updatedAnswers));
    }
  }

  Future<void> _onSubmitQuiz(SubmitQuiz event, Emitter<QuizState> emit) async {
    if (state is QuizLoaded) {
      final currentState = state as QuizLoaded;

      // 제출 가능한 상태 확인
      if (!currentState.canSubmit) {
        emit(
          QuizError(
            message: '퀴즈를 제출할 수 없는 상태입니다.',
            quizResponse: currentState.quizResponse,
            answers: currentState.answers,
          ),
        );
        return;
      }

      emit(
        QuizSubmitting(
          quizResponse: currentState.quizResponse,
          answers: currentState.answers,
        ),
      );

      try {
        await _repository.submitQuiz(
          quizId: event.quizId,
          answers: currentState.answers,
        );

        emit(
          QuizSubmitted(
            quizResponse: currentState.quizResponse,
            answers: currentState.answers,
          ),
        );
      } on QuizException catch (e) {
        emit(
          QuizError(
            message: e.message,
            quizResponse: currentState.quizResponse,
            answers: currentState.answers,
          ),
        );
      } catch (e) {
        emit(
          QuizError(
            message: '퀴즈 제출에 실패했습니다: $e',
            quizResponse: currentState.quizResponse,
            answers: currentState.answers,
          ),
        );
      }
    }
  }

  Future<void> _onLoadQuizResult(
    LoadQuizResult event,
    Emitter<QuizState> emit,
  ) async {
    emit(const QuizLoading());

    try {
      final resultResponse = await _repository.getQuizResult(event.quizId);
      final originalQuiz = await _repository.getQuiz(event.quizId);

      emit(
        QuizResultLoaded(
          resultResponse: resultResponse,
          originalQuiz: originalQuiz,
        ),
      );
    } on QuizException catch (e) {
      emit(QuizError(message: e.message));
    } catch (e) {
      emit(QuizError(message: '퀴즈 결과를 불러오는데 실패했습니다: $e'));
    }
  }

  void _onResetQuiz(ResetQuiz event, Emitter<QuizState> emit) {
    emit(const QuizInitial());
  }
}
