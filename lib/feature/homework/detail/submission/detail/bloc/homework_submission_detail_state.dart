import 'package:ormee_app/feature/homework/detail/submission/detail/data/model.dart';

abstract class HomeworkSubmissionDetailState {}

class HomeworkSubmissionDetailInitial extends HomeworkSubmissionDetailState {}

class HomeworkSubmissionDetailLoading extends HomeworkSubmissionDetailState {}

class HomeworkSubmissionDetailLoaded extends HomeworkSubmissionDetailState {
  final HomeworkSubmissionDetailModel submission;

  HomeworkSubmissionDetailLoaded(this.submission);
}

class HomeworkSubmissionDetailError extends HomeworkSubmissionDetailState {
  final String message;

  HomeworkSubmissionDetailError(this.message);
}