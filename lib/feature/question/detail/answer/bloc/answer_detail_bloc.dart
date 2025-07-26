import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/question/detail/answer/bloc/answer_detail_event.dart';
import 'package:ormee_app/feature/question/detail/answer/bloc/answer_detail_state.dart';
import 'package:ormee_app/feature/question/detail/answer/data/repository.dart';

class AnswerDetailBloc extends Bloc<AnswerDetailEvent, AnswerDetailState> {
  final AnswerDetailRepository repository;

  AnswerDetailBloc(this.repository) : super(AnswerDetailInitial()) {
    on<FetchAnswerDetail>((event, emit) async {
      emit(AnswerDetailLoading());
      try {
        final answer = await repository.readAnswer(event.questionId);
        emit(AnswerDetailLoaded(answer));
      } catch(e) {
        emit(AnswerDetailError(e.toString()));
      }
    });
  }
}