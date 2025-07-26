import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/question/detail/bloc/question_detail_event.dart';
import 'package:ormee_app/feature/question/detail/bloc/question_detail_state.dart';
import 'package:ormee_app/feature/question/detail/data/repository.dart';

class QuestionDetailBloc
    extends Bloc<QuestionDetailEvent, QuestionDetailState> {
  final QuestionDetailRepository repository;

  QuestionDetailBloc(this.repository) : super(QuestionDetailInitial()) {
    on<FetchQuestionDetail>((event, emit) async {
      emit(QuestionDetailLoading());
      try {
        final question = await repository.readQuestion(event.questionId);
        emit(QuestionDetailLoaded(question));
      } catch (e) {
        emit(QuestionDetailError(e.toString()));
      }
    });
  }
}
