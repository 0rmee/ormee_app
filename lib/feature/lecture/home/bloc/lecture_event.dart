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

class EnterLecture extends LectureHomeEvent {
  final int lectureId;

  const EnterLecture(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}

class ShowLectureDialog extends LectureHomeEvent {
  final int lectureId;

  const ShowLectureDialog(this.lectureId);

  @override
  List<Object> get props => [lectureId];
}
