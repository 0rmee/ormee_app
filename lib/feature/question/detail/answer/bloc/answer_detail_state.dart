import 'package:ormee_app/feature/question/detail/answer/data/model.dart';

abstract class AnswerDetailState {}

class AnswerDetailInitial extends AnswerDetailState {}

class AnswerDetailLoading extends AnswerDetailState {}

class AnswerDetailLoaded extends AnswerDetailState {
  final AnswerDetailModel answer;

  AnswerDetailLoaded(this.answer);
}

class AnswerDetailError extends AnswerDetailState {
  final String message;

  AnswerDetailError(this.message);
}