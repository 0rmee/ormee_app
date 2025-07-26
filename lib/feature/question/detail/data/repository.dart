import 'package:ormee_app/feature/question/detail/data/model.dart';
import 'package:ormee_app/feature/question/detail/data/remote_datasource.dart';

class QuestionDetailRepository {
  final QuestionDetailRemoteDataSource remoteDataSource;

  QuestionDetailRepository(this.remoteDataSource);

  Future<QuestionDetailModel> readQuestion(int questionId) {
    return remoteDataSource.fetchQuestionDetail(questionId);
  }
}