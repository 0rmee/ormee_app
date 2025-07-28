// quiz_event.dart
import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuiz extends QuizEvent {
  final int quizId;

  const LoadQuiz(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class UpdateAnswer extends QuizEvent {
  final int problemId;
  final String answer;

  const UpdateAnswer({required this.problemId, required this.answer});

  @override
  List<Object?> get props => [problemId, answer];
}

class SubmitQuiz extends QuizEvent {
  final int quizId;

  const SubmitQuiz(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class LoadQuizResult extends QuizEvent {
  final int quizId;

  const LoadQuizResult(this.quizId);

  @override
  List<Object?> get props => [quizId];
}

class ResetQuiz extends QuizEvent {
  const ResetQuiz();
}
