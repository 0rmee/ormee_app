abstract class NoticeEvent {}

class FetchAllNotices extends NoticeEvent {
  final int lectureId;

  FetchAllNotices(this.lectureId);
}
