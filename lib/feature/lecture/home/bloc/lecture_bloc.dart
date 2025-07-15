import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_state.dart';
import 'package:ormee_app/feature/lecture/home/data/repository.dart';

class LectureHomeBloc extends Bloc<LectureHomeEvent, LectureHomeState> {
  final LectureHomeRepository repository;

  LectureHomeBloc(this.repository) : super(LectureHomeInitial()) {
    on<FetchLectures>((event, emit) async {
      emit(LectureHomeLoading());
      try {
        final lectures = await repository.getLectures();
        emit(LectureHomeLoaded(lectures));
      } catch (e) {
        emit(LectureHomeError(e.toString()));
      }
    });
  }
}
