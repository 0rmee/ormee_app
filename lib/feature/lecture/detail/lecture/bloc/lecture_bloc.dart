import 'package:flutter_bloc/flutter_bloc.dart';
import 'lecture_event.dart';
import 'lecture_state.dart';
import '../data/lecture_repository.dart';

class LectureBloc extends Bloc<LectureEvent, LectureState> {
  final LectureRepository repository;

  LectureBloc(this.repository) : super(LectureInitial()) {
    on<FetchLectureDetail>((event, emit) async {
      emit(LectureLoading());
      try {
        final lecture = await repository.getLectureDetail(event.lectureId);
        emit(LectureLoaded(lecture));
      } catch (e) {
        emit(LectureError(e.toString()));
      }
    });
  }
}
