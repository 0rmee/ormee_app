abstract class QuestionListEvent {}

class FetchQuestionList extends QuestionListEvent {
  final int lectureId;

  FetchQuestionList(this.lectureId);
}