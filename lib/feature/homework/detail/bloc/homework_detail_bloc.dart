import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/homework/detail/bloc/homework_detail_event.dart';
import 'package:ormee_app/feature/homework/detail/bloc/homework_detail_state.dart';
import 'package:ormee_app/feature/homework/detail/data/repository.dart';

class HomeworkDetailBloc
    extends Bloc<HomeworkDetailEvent, HomeworkDetailState> {
  final HomeworkDetailRepository repository;

  HomeworkDetailBloc(this.repository) : super(HomeworkDetailInitial()) {
    on<FetchHomeworkDetail>((event, emit) async {
      emit(HomeworkDetailLoading());
      try {
        final homework = await repository.readHomework(event.homeworkId);
        emit(HomeworkDetailLoaded(homework));
      } catch (e) {
        emit(HomeworkDetailError(e.toString()));
      }
    });
  }
}
