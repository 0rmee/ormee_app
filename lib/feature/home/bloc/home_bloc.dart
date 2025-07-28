import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/home/data/repository.dart';

import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HomeRepository repository;

  HomeBloc(this.repository) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      final banners = await repository.getBanners();
      final lectures = await repository.getLectures();
      final quizzes = await repository.getQuizzes();
      final homeworks = await repository.getHomeworks();

      emit(
        HomeLoaded(
          banners: banners,
          lectures: lectures,
          quizzes: quizzes,
          homeworks: homeworks,
        ),
      );
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
