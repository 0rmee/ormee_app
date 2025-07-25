import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/bloc/feedback_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/bloc/feedback_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/repository.dart';

class FeedbackDetailBloc
    extends Bloc<FeedbackDetailEvent, FeedbackDetailState> {
  final FeedbackDetailRepository repository;

  FeedbackDetailBloc(this.repository) : super(FeedbackDetailInitial()) {
    on<FetchFeedbackDetail>((event, emit) async {
      emit(FeedbackDetailLoading());
      try {
        final feedbacks = await repository.readHomework(event.submissionId);
        emit(FeedbackDetailLoaded(feedbacks));
      } catch (e) {
        emit(FeedbackDetailError(e.toString()));
      }
    });
  }
}