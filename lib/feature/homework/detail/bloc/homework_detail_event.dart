abstract class HomeworkDetailEvent {}

class FetchHomeworkDetail extends HomeworkDetailEvent {
  final int homeworkId;

  FetchHomeworkDetail(this.homeworkId);
}
