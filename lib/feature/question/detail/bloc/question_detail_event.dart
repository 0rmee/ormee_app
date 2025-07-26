abstract class QuestionDetailEvent {}

class FetchQuestionDetail extends QuestionDetailEvent {
  final int questionId;

  FetchQuestionDetail(this.questionId);
}