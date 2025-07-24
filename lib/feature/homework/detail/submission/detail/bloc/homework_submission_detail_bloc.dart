import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/bloc/homework_submission_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/bloc/homework_submission_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/data/repository.dart';

class HomeworkSubmissionDetailBloc
    extends Bloc<HomeworkSubmissionDetailEvent, HomeworkSubmissionDetailState> {
  final HomeworkSubmissionDetailRepository repository;

  HomeworkSubmissionDetailBloc(this.repository) : super(HomeworkSubmissionDetailInitial()) {
    on<FetchHomeworkSubmissionDetail>((event, emit) async {
      emit(HomeworkSubmissionDetailLoading());
      try {
        final submission = await repository.readHomework(event.homeworkId);
        emit(HomeworkSubmissionDetailLoaded(submission));
      } catch (e) {
        emit(HomeworkSubmissionDetailError(e.toString()));
      }
    });
  }
}