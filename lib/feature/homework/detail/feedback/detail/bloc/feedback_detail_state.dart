import 'package:ormee_app/feature/homework/detail/feedback/detail/data/model.dart';

abstract class FeedbackDetailState {}

class FeedbackDetailInitial extends FeedbackDetailState {}

class FeedbackDetailLoading extends FeedbackDetailState {}

class FeedbackDetailLoaded extends FeedbackDetailState {
  final List<FeedbackDetailModel> feedbacks;

  FeedbackDetailLoaded(this.feedbacks);
}

class FeedbackDetailError extends FeedbackDetailState {
  final String message;

  FeedbackDetailError(this.message);
}