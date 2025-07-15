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

    on<LeaveLecture>((event, emit) async {
      try {
        await repository.leaveLecture(event.lectureId);
        add(FetchLectures()); // 퇴장 후 강의 목록 갱신
      } catch (e) {
        emit(LectureHomeError('강의 퇴장 실패: ${e.toString()}'));
      }
    });
  }
}
