abstract class AnswerDetailEvent {}

class FetchAnswerDetail extends AnswerDetailEvent {
  final int questionId;

  FetchAnswerDetail(this.questionId);
}