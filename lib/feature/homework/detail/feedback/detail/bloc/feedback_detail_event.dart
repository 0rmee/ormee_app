abstract class FeedbackDetailEvent {}

class FetchFeedbackDetail extends FeedbackDetailEvent {
  final int submissionId;

  FetchFeedbackDetail(this.submissionId);
}