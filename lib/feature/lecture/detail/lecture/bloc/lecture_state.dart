import '../data/lecture_model.dart';

abstract class LectureState {}

class LectureInitial extends LectureState {}

class LectureLoading extends LectureState {}

class LectureLoaded extends LectureState {
  final LectureModel lecture;

  LectureLoaded(this.lecture);
}

class LectureError extends LectureState {
  final String message;

  LectureError(this.message);
}
