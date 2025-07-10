import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_model.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_remote_datasource.dart';

class QuizRepository {
  final QuizRemoteDataSource remote;

  QuizRepository(this.remote);

  Future<List<QuizModel>> getQuizzes(int lectureId) {
    return remote.fetchQuizzes(lectureId);
  }
}
