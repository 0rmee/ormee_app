import 'package:equatable/equatable.dart';

abstract class LectureHomeEvent extends Equatable {
  const LectureHomeEvent();

  @override
  List<Object?> get props => [];
}

class FetchLectures extends LectureHomeEvent {}

class LeaveLecture extends LectureHomeEvent {
  final int lectureId;

  const LeaveLecture(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}
