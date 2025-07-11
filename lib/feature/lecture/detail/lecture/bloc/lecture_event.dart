abstract class LectureEvent {}

class FetchLectureDetail extends LectureEvent {
  final int lectureId;

  FetchLectureDetail(this.lectureId);
}
