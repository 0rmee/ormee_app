import 'package:ormee_app/feature/notice/detail/data/model.dart';
import 'package:ormee_app/feature/notice/detail/data/remote_datasource.dart';

class NoticeDetailRepository {
  final NoticeDetailRemoteDataSource remoteDataSource;

  NoticeDetailRepository(this.remoteDataSource);

  Future<NoticeDetailModel> readNotice(int noticeId) {
    return remoteDataSource.fetchNoticeDetail(noticeId);
  }

  Future<void> likeNotice(int noticeId) async {
    await remoteDataSource.likeNotice(noticeId);
  }

  Future<void> unlikeNotice(int noticeId) async {
    await remoteDataSource.unlikeNotice(noticeId);
  }
}