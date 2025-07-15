import 'package:ormee_app/feature/lecture/home/data/datasources/remote_datasource.dart';
import 'package:ormee_app/feature/lecture/home/data/models/model.dart';

class LectureRepository {
  final LectureRemoteDataSource remoteDataSource;

  LectureRepository(this.remoteDataSource);

  Future<List<Lecture>> getLectures() {
    return remoteDataSource.fetchLectures();
  }
}
