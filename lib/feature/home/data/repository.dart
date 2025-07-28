import 'package:ormee_app/feature/home/data/models/banner.dart';
import 'package:ormee_app/feature/home/data/models/homework_card.dart';
import 'package:ormee_app/feature/home/data/models/lecture_card.dart';
import 'package:ormee_app/feature/home/data/models/quiz_card.dart';
import 'package:ormee_app/feature/home/data/remote_datasource.dart';

class HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepository(this.remoteDataSource);

  Future<List<BannerModel>> getBanners() {
    return remoteDataSource.fetchBanners();
  }

  Future<List<LectureCard>> getLectures() {
    return remoteDataSource.fetchLectures();
  }

  Future<List<QuizCard>> getQuizzes() {
    return remoteDataSource.fetchQuizzes();
  }

  Future<List<HomeworkCard>> getHomeworks() {
    return remoteDataSource.fetchHomeworks();
  }
}
