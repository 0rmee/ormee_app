import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_model.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_remote_datasource.dart';

class LectureRepository {
  final LectureRemoteDataSource remoteDataSource;

  LectureRepository(this.remoteDataSource);

  Future<LectureModel> getLectureDetail(int lectureId) {
    return remoteDataSource.fetchLectureDetail(lectureId);
  }
}
