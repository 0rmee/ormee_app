import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/question/list/bloc/question_list_event.dart';
import 'package:ormee_app/feature/question/list/bloc/question_list_state.dart';
import 'package:ormee_app/feature/question/list/data/repository.dart';

class QuestionListBloc
    extends Bloc<QuestionListEvent, QuestionListState> {
  final QuestionListRepository repository;

  QuestionListBloc(this.repository) : super(QuestionListInitial()) {
    on<FetchQuestionList>((event, emit) async {
      emit(QuestionListLoading());
      try {
        final feedbacks = await repository.readQuestions(event.lectureId);
        emit(QuestionListLoaded(feedbacks));
      } catch (e) {
        emit(QuestionListError(e.toString()));
      }
    });
  }
}