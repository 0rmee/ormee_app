import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_event.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_state.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_repository.dart';

class HomeworkBloc extends Bloc<HomeworkEvent, HomeworkState> {
  final HomeworkRepository repository;

  HomeworkBloc(this.repository) : super(HomeworkInitial()) {
    on<FetchHomeworks>((event, emit) async {
      emit(HomeworkLoading());
      try {
        final homeworks = await repository.getHomeworks(event.lectureId);
        emit(HomeworkLoaded(homeworks));
      } catch (e) {
        emit(HomeworkError(e.toString()));
      }
    });
  }
}
