import 'package:ormee_app/feature/lecture/detail/homework/data/homework_model.dart';

abstract class HomeworkState {}

class HomeworkInitial extends HomeworkState {}

class HomeworkLoading extends HomeworkState {}

class HomeworkLoaded extends HomeworkState {
  final List<HomeworkModel> homeworks;

  HomeworkLoaded(this.homeworks);
}

class HomeworkError extends HomeworkState {
  final String message;

  HomeworkError(this.message);
}
