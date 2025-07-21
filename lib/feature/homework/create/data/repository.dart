import 'package:ormee_app/feature/homework/create/data/model.dart';
import 'package:ormee_app/feature/homework/create/data/remote_datasource.dart';

class HomeworkRepository {
  final HomeworkCreateRemoteDataSource remoteDataSource;

  HomeworkRepository(this.remoteDataSource);

  Future<void> postHomework(int homeworkId, HomeworkRequest request) async {
    return remoteDataSource.postHomework(homeworkId, request);
  }
}
