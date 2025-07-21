abstract class NoticeDetailEvent {}

class FetchNoticeDetail extends NoticeDetailEvent {
  final int noticeId;

  FetchNoticeDetail(this.noticeId);
}