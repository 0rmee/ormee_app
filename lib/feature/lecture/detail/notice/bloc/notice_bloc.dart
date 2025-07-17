import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_event.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_state.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_repository.dart';

class NoticeBloc extends Bloc<NoticeEvent, NoticeState> {
  final NoticeRepository repository;

  NoticeBloc(this.repository) : super(NoticeInitial()) {
    on<FetchNotices>((event, emit) async {
      emit(NoticeLoading());
      try {
        final notices = await repository.getNotices(event.lectureId);
        emit(NoticeLoaded(notices));
      } catch (e) {
        emit(NoticeError(e.toString()));
      }
    });
  }
}
