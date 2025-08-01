abstract class MyPageListState {}

class MyPageListInitial extends MyPageListState {}

class MyPageListLoading extends MyPageListState {}

class MyPageListLoaded extends MyPageListState {
  final String name;

  MyPageListLoaded(this.name);
}

class MyPageListError extends MyPageListState {
  final String message;

  MyPageListError(this.message);
}