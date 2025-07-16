import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/lecture/home/data/model.dart';

abstract class LectureHomeState extends Equatable {
  const LectureHomeState();

  @override
  List<Object?> get props => [];
}

class LectureHomeInitial extends LectureHomeState {}

class LectureHomeLoading extends LectureHomeState {}

class LectureHomeLoaded extends LectureHomeState {
  final List<LectureHome> lectures;

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

class LectureDialogReady extends LectureHomeState {
  final LectureHome lecture;

  const LectureDialogReady(this.lecture);

  @override
  List<Object?> get props => [lecture];
}
