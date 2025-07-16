import 'package:ormee_app/feature/lecture/home/data/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/model.dart';

class LectureHomeRepository {
  final LectureHomeRemoteDataSource remoteDataSource;

  LectureHomeRepository(this.remoteDataSource);

  Future<List<LectureHome>> getLectures() {
    return remoteDataSource.fetchLectures();
  }

  Future<void> leaveLecture(int lectureId) {
    return remoteDataSource.leaveLecture(lectureId);
  }

  Future<void> enterLecture(int lectureId) {
    return remoteDataSource.enterLecture(lectureId);
  }

  Future<LectureHome> getLectureById(int lectureId) {
    return remoteDataSource.fetchLectureById(lectureId);
  }
}
