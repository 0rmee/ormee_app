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

    on<ToggleLike>((event, emit) async {
      if (state is !NoticeDetailLoaded) return;
      final currentState = state as NoticeDetailLoaded;
      final notice = currentState.notice;

      try {
        if (event.isLiked) {
          await repository.unlikeNotice(event.noticeId);
        } else {
          await repository.likeNotice(event.noticeId);
        }

        notice.isLiked = !notice.isLiked;
        emit(NoticeDetailLoaded(notice));

      } catch (e) {
        emit(NoticeDetailError('좋아요 실패: ${e.toString()}'));
        emit(currentState);  // 실패 시 기존 상태 복구
      }
    });
  }
}