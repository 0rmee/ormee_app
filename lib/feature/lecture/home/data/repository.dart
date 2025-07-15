import 'package:ormee_app/feature/lecture/home/data/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/model.dart';

class LectureHomeRepository {
  final LectureHomeRemoteDataSource remoteDataSource;

  LectureHomeRepository(this.remoteDataSource);

  Future<List<LectureHome>> getLectures() {
    return remoteDataSource.fetchLectures();
  }
}
