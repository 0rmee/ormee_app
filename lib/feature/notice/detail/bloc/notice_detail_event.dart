abstract class NoticeDetailEvent {}

class FetchNoticeDetail extends NoticeDetailEvent {
  final int noticeId;

  FetchNoticeDetail(this.noticeId);
}

class ToggleLike extends NoticeDetailEvent {
  final int noticeId;
  final bool isLiked;

  ToggleLike({required this.noticeId, required this.isLiked});
}