import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_model.dart';

abstract class QuizState {}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<QuizModel> quizzes;

  QuizLoaded(this.quizzes);
}

class QuizError extends QuizState {
  final String message;

  QuizError(this.message);
}
