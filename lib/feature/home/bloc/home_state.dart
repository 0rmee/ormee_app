import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/home/data/models/banner.dart';
import 'package:ormee_app/feature/home/data/models/homework_card.dart';
import 'package:ormee_app/feature/home/data/models/lecture_card.dart';
import 'package:ormee_app/feature/home/data/models/quiz_card.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<BannerModel> banners;
  final List<LectureCard> lectures;
  final List<QuizCard> quizzes;
  final List<HomeworkCard> homeworks;

  const HomeLoaded({
    required this.banners,
    required this.lectures,
    required this.quizzes,
    required this.homeworks,
  });

  @override
  List<Object> get props => [lectures, quizzes, homeworks];
}

class HomeError extends HomeState {
  final String message;

  const HomeError(this.message);

  @override
  List<Object> get props => [message];
}
