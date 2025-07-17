abstract class NoticeEvent {}

class FetchNotices extends NoticeEvent {
  final int lectureId;
  FetchNotices(this.lectureId);
}
