// quiz_state.dart
import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/quiz/detail/data/model.dart';
import 'package:ormee_app/feature/quiz/detail/data/repository.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {
  const QuizInitial();
}

class QuizLoading extends QuizState {
  const QuizLoading();
}

class QuizLoaded extends QuizState {
  final QuizResponse quizResponse;
  final Map<int, String> answers;
  final QuizStatus status;

  const QuizLoaded({
    required this.quizResponse,
    required this.answers,
    required this.status,
  });

  QuizDetail get detail => quizResponse.data.detailInfo;
  QuizTake get take => quizResponse.data.takeInfo;

  bool get canSubmit => status == QuizStatus.inProgress && answers.isNotEmpty;
  bool get isSubmitted => status == QuizStatus.submitted;
  double get progress =>
      take.totalProblems > 0 ? (answers.length / take.totalProblems) * 100 : 0;

  @override
  List<Object?> get props => [quizResponse, answers, status];

  QuizLoaded copyWith({
    QuizResponse? quizResponse,
    Map<int, String>? answers,
    QuizStatus? status,
  }) {
    return QuizLoaded(
      quizResponse: quizResponse ?? this.quizResponse,
      answers: answers ?? this.answers,
      status: status ?? this.status,
    );
  }
}

class QuizSubmitting extends QuizState {
  final QuizResponse quizResponse;
  final Map<int, String> answers;

  const QuizSubmitting({required this.quizResponse, required this.answers});

  @override
  List<Object?> get props => [quizResponse, answers];
}

class QuizSubmitted extends QuizState {
  final QuizResponse quizResponse;
  final Map<int, String> answers;

  const QuizSubmitted({required this.quizResponse, required this.answers});

  @override
  List<Object?> get props => [quizResponse, answers];
}

class QuizResultLoaded extends QuizState {
  final QuizResultResponse resultResponse;
  final QuizResponse originalQuiz;

  const QuizResultLoaded({
    required this.resultResponse,
    required this.originalQuiz,
  });

  QuizResultData get result => resultResponse.data;
  QuizDetail get detail => originalQuiz.data.detailInfo;

  @override
  List<Object?> get props => [resultResponse, originalQuiz];
}

class QuizError extends QuizState {
  final String message;
  final QuizResponse? quizResponse;
  final Map<int, String>? answers;

  const QuizError({required this.message, this.quizResponse, this.answers});

  @override
  List<Object?> get props => [message, quizResponse, answers];
}
