abstract class HomeworkSubmissionDetailEvent {}

class FetchHomeworkSubmissionDetail extends HomeworkSubmissionDetailEvent {
  final int homeworkId;

  FetchHomeworkSubmissionDetail(this.homeworkId);
}