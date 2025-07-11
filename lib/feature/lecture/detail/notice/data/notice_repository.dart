import 'package:ormee_app/feature/lecture/detail/notice/data/notice_model.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_remote_datasource.dart';

class NoticeRepository {
  final NoticeRemoteDataSource remoteDataSource;

  NoticeRepository(this.remoteDataSource);

  Future<List<NoticeModel>> getNotices(int lectureId) {
    return remoteDataSource.fetchNotices(lectureId);
  }
}
