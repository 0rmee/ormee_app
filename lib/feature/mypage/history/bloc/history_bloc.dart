import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/history/bloc/history_event.dart';
import 'package:ormee_app/feature/mypage/history/bloc/history_state.dart';
import 'package:ormee_app/feature/mypage/history/data/remote_datasource.dart';

class LectureHistoryBloc
    extends Bloc<LectureHistoryEvent, LectureHistoryState> {
  final LectureHistoryRemoteDataSource _remoteDataSource;

  LectureHistoryBloc(this._remoteDataSource) : super(LectureHistoryInitial()) {
    on<LoadLectureHistory>(_onLoadLectureHistory);
  }

  Future<void> _onLoadLectureHistory(
    LoadLectureHistory event,
    Emitter<LectureHistoryState> emit,
  ) async {
    emit(LectureHistoryLoading());

    try {
      final data = await _remoteDataSource.fetchLectureHistory();

      emit(
        LectureHistoryLoaded(
          openLectures: data.openLectures,
          closedLectures: data.closedLectures,
        ),
      );
    } catch (e) {
      emit(LectureHistoryError(message: e.toString()));
    }
  }
}
