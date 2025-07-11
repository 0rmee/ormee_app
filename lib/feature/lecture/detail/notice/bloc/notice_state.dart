import 'package:ormee_app/feature/lecture/detail/notice/data/notice_model.dart';

abstract class NoticeState {}

class NoticeInitial extends NoticeState {}

class NoticeLoading extends NoticeState {}

class NoticeLoaded extends NoticeState {
  final List<NoticeModel> notices;

  NoticeLoaded(this.notices);
}

class NoticeError extends NoticeState {
  final String message;

  NoticeError(this.message);
}
