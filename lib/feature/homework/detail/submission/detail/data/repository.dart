import 'package:ormee_app/feature/homework/detail/submission/detail/data/model.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/data/remote_datasource.dart';

class HomeworkSubmissionDetailRepository {
  final HomeworkSubmissionDetailRemoteDataSource remoteDataSource;

  HomeworkSubmissionDetailRepository(this.remoteDataSource);

  Future<HomeworkSubmissionDetailModel> readHomework(int homeworkId) {
    return remoteDataSource.fetchHomeworkSubmissionDetail(homeworkId);
  }
}