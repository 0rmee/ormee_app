import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/notice/detail/bloc/notice_detail_event.dart';
import 'package:ormee_app/feature/notice/detail/bloc/notice_detail_state.dart';
import 'package:ormee_app/feature/notice/detail/data/repository.dart';

class NoticeDetailBloc extends Bloc<NoticeDetailEvent, NoticeDetailState> {
  final NoticeDetailRepository repository;

  NoticeDetailBloc(this.repository) : super(NoticeDetailInitial()) {
    on<FetchNoticeDetail>((event, emit) async {
      emit(NoticeDetailLoading());
      try {
        final notice = await repository.readNotice(event.noticeId);
        emit(NoticeDetailLoaded(notice));
      } catch (e) {
        emit(NoticeDetailError(e.toString()));
      }
    });
  }
}