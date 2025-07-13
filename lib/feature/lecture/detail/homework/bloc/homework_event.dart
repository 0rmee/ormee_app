abstract class HomeworkEvent {}

class FetchHomeworks extends HomeworkEvent {
  final int lectureId;

  FetchHomeworks(this.lectureId);
}
