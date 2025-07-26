import 'package:ormee_app/feature/question/detail/data/model.dart';

abstract class QuestionDetailState {}

class QuestionDetailInitial extends QuestionDetailState {}

class QuestionDetailLoading extends QuestionDetailState {}

class QuestionDetailLoaded extends QuestionDetailState {
  final QuestionDetailModel question;

  QuestionDetailLoaded(this.question);
}

class QuestionDetailError extends QuestionDetailState {
  final String message;

  QuestionDetailError(this.message);
}
