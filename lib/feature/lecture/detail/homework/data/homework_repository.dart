import 'package:ormee_app/feature/lecture/detail/homework/data/homework_model.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_remote_datasource.dart';

class HomeworkRepository {
  final HomeworkRemoteDataSource remote;

  HomeworkRepository(this.remote);

  Future<List<HomeworkModel>> getHomeworks(int lectureId) {
    return remote.fetchHomeworks(lectureId);
  }
}
