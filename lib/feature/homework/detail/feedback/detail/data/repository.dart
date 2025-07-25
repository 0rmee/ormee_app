import 'package:ormee_app/feature/homework/detail/feedback/detail/data/model.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/remote_repository.dart';

class FeedbackDetailRepository {
  final FeedbackDetailRemoteDataSource remoteDataSource;

  FeedbackDetailRepository(this.remoteDataSource);

  Future<List<FeedbackDetailModel>> readHomework(int homeworkId) {
    return remoteDataSource.fetchFeedbackDetail(homeworkId);
  }
}