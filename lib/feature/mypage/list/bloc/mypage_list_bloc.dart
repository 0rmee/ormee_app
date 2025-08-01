import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_event.dart';
import 'package:ormee_app/feature/mypage/list/bloc/mypage_list_state.dart';
import 'package:ormee_app/feature/mypage/list/data/repository.dart';

class MyPageListBloc
    extends Bloc<MyPageListEvent, MyPageListState> {
  final MyPageProfileRepository repository;

  MyPageListBloc(this.repository) : super(MyPageListInitial()) {
    on<FetchMyPageList>((event, emit) async {
      emit(MyPageListLoading());
      try {
        final homework = await repository.readName();
        emit(MyPageListLoaded(homework));
      } catch (e) {
        emit(MyPageListError(e.toString()));
      }
    });
  }
}