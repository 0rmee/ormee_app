import 'package:ormee_app/feature/homework/detail/data/model.dart';

abstract class HomeworkDetailState {}

class HomeworkDetailInitial extends HomeworkDetailState {}

class HomeworkDetailLoading extends HomeworkDetailState {}

class HomeworkDetailLoaded extends HomeworkDetailState {
  final HomeworkDetailModel homework;

  HomeworkDetailLoaded(this.homework);
}

class HomeworkDetailError extends HomeworkDetailState {
  final String message;

  HomeworkDetailError(this.message);
}
