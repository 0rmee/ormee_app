import 'package:ormee_app/feature/homework/detail/data/model.dart';
import 'package:ormee_app/feature/homework/detail/data/remote_datasource.dart';

class HomeworkDetailRepository {
  final HomeworkDetailRemoteDataSource remoteDataSource;

  HomeworkDetailRepository(this.remoteDataSource);

  Future<HomeworkDetailModel> readHomework(int homeworkId) {
    return remoteDataSource.fetchHomeworkDetail(homeworkId);
  }
}
