import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/lecture/home/data/models/model.dart';

abstract class LectureHomeState extends Equatable {
  const LectureHomeState();

  @override
  List<Object?> get props => [];
}

class LectureHomeInitial extends LectureHomeState {}

class LectureHomeLoading extends LectureHomeState {}

class LectureHomeLoaded extends LectureHomeState {
  final List<Lecture> lectures;

  const LectureHomeLoaded(this.lectures);

  @override
  List<Object?> get props => [lectures];
}

class LectureHomeError extends LectureHomeState {
  final String message;

  const LectureHomeError(this.message);

  @override
  List<Object?> get props => [message];
}
