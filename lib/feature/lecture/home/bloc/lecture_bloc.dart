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

    on<EnterLecture>((event, emit) async {
      try {
        await repository.enterLecture(event.lectureId);
        add(FetchLectures()); // 입장 후 목록 갱신
      } catch (e) {
        emit(LectureHomeError('강의실 입장 실패: ${e.toString()}'));
      }
    });

    on<ShowLectureDialog>((event, emit) async {
      try {
        final lecture = await repository.getLectureById(event.lectureId);
        emit(LectureDialogReady(lecture));
      } catch (e) {
        emit(LectureHomeError('강의 정보 조회 실패: ${e.toString()}'));
      }
    });
  }
}
