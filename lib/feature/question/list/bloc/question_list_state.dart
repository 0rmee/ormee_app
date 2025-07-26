import 'package:ormee_app/feature/question/list/data/model.dart';

abstract class QuestionListState {}

class QuestionListInitial extends QuestionListState {}

class QuestionListLoading extends QuestionListState {}

class QuestionListLoaded extends QuestionListState {
  final List<QuestionListModel> questions;

  QuestionListLoaded(this.questions);
}

class QuestionListError extends QuestionListState {
  final String message;

  QuestionListError(this.message);
}