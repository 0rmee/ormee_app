import 'package:ormee_app/feature/question/list/data/model.dart';
import 'package:ormee_app/feature/question/list/data/remote_datasource.dart';

class QuestionListRepository {
  final QuestionListRemoteDataSource remoteDataSource;

  QuestionListRepository(this.remoteDataSource);

  Future<List<QuestionListModel>> readQuestions(int lectureId) {
    return remoteDataSource.fetchQuestionList(lectureId);
  }
}