import 'package:ormee_app/feature/question/detail/answer/data/model.dart';
import 'package:ormee_app/feature/question/detail/answer/data/remote_datasource.dart';

class AnswerDetailRepository {
  final AnswerDetailRemoteDataSource remoteDataSource;

  AnswerDetailRepository(this.remoteDataSource);

  Future<AnswerDetailModel> readAnswer(int questionId) {
    return remoteDataSource.fetchAnswerDetail(questionId);
  }
}