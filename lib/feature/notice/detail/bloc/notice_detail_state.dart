import 'package:ormee_app/feature/notice/detail/data/model.dart';

abstract class NoticeDetailState {}

class NoticeDetailInitial extends NoticeDetailState {}

class NoticeDetailLoading extends NoticeDetailState {}

class NoticeDetailLoaded extends NoticeDetailState {
  final NoticeDetailModel notice;

  NoticeDetailLoaded(this.notice);
}

class NoticeDetailError extends NoticeDetailState {
  final String message;

  NoticeDetailError(this.message);
}