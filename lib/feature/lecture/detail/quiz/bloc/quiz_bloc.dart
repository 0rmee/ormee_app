import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_state.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_repository.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final QuizRepository repository;

  QuizBloc(this.repository) : super(QuizInitial()) {
    on<FetchQuizzes>((event, emit) async {
      emit(QuizLoading());
      try {
        final quizzes = await repository.getQuizzes(event.lectureId);
        emit(QuizLoaded(quizzes));
      } catch (e) {
        emit(QuizError(e.toString()));
      }
    });
  }
}
