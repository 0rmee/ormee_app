import 'package:flutter_bloc/flutter_bloc.dart';
import 'question_create_event.dart';
import 'question_create_state.dart';

class QuestionCreateBloc
    extends Bloc<QuestionCreateEvent, QuestionCreateState> {
  QuestionCreateBloc() : super(QuestionCreateState(title: '')) {
    on<TitleChanged>((event, emit) {
      final newTitle = event.title.length <= 20
          ? event.title
          : event.title.substring(0, 20); // 20자 제한
      emit(state.copyWith(title: newTitle));
    });
  }
}
