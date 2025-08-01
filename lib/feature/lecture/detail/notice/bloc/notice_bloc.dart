import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_event.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_state.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_repository.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository repository;

  NoticeBloc(this.repository) : super(NoticeInitial()) {
    on<FetchAllNotices>((event, emit) async {
      emit(NoticeLoading());
      try {
        // 고정 공지와 일반 공지를 모두 가져오기
        final notices = await repository.getNotices(event.lectureId);
        final pinnedNotices = await repository.getPinnedNotices(
          event.lectureId,
        );

        emit(NoticeLoaded(notices, pinnedNotices));
      } catch (e) {
        emit(NoticeError(e.toString()));
      }
    });
  }
}
