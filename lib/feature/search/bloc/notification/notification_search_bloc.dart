import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/search/bloc/notification/notification_search_event.dart';
import 'package:ormee_app/feature/search/bloc/notification/notification_search_state.dart';
import 'package:ormee_app/feature/search/data/notification/repository.dart';

class NotificationSearchBloc
    extends Bloc<NotificationSearchEvent, NotificationSearchState> {
  final NotificationSearchRepository _repository;
  Timer? _debounce;

  NotificationSearchBloc({required NotificationSearchRepository repository})
    : _repository = repository,
      super(const NotificationSearchState()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchNotifications>(_onSearchNotifications);
    on<SearchFromHistory>(_onSearchFromHistory);
    on<DeleteSearchHistory>(_onDeleteSearchHistory);
    on<ClearAllSearchHistory>(_onClearAllSearchHistory);
    on<ClearSearchResults>(_onClearSearchResults);
    on<UpdateSearchKeyword>(_onUpdateSearchKeyword);
  }

  @override
  Future<void> close() {
    _debounce?.cancel();
    return super.close();
  }

  Future<void> _onLoadSearchHistory(
    LoadSearchHistory event,
    Emitter<NotificationSearchState> emit,
  ) async {
    emit(state.copyWith(status: NotificationSearchStatus.loading));

    try {
      final searchHistory = await _repository.getSearchHistory();
      emit(
        state.copyWith(
          status: NotificationSearchStatus.success,
          searchHistory: searchHistory,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationSearchStatus.failure,
          errorMessage: '검색 기록을 불러오는데 실패했습니다',
        ),
      );
    }
  }

  Future<void> _onSearchNotifications(
    SearchNotifications event,
    Emitter<NotificationSearchState> emit,
  ) async {
    if (event.keyword.trim().isEmpty) {
      emit(
        state.copyWith(
          notifications: [],
          hasSearched: false,
          currentKeyword: event.keyword,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        isSearching: true,
        currentKeyword: event.keyword,
        errorMessage: null,
      ),
    );

    try {
      final notifications = await _repository.searchNotifications(
        event.keyword,
      );
      final updatedHistory = await _repository.getSearchHistory();

      emit(
        state.copyWith(
          status: NotificationSearchStatus.success,
          notifications: notifications,
          searchHistory: updatedHistory,
          isSearching: false,
          hasSearched: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationSearchStatus.failure,
          errorMessage: '검색 중 오류가 발생했습니다',
          isSearching: false,
          hasSearched: true,
        ),
      );
    }
  }

  Future<void> _onSearchFromHistory(
    SearchFromHistory event,
    Emitter<NotificationSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        isSearching: true,
        currentKeyword: event.keyword,
        errorMessage: null,
      ),
    );

    try {
      final notifications = await _repository.searchNotifications(
        event.keyword,
      );
      final updatedHistory = await _repository.getSearchHistory();

      emit(
        state.copyWith(
          status: NotificationSearchStatus.success,
          notifications: notifications,
          searchHistory: updatedHistory,
          isSearching: false,
          hasSearched: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NotificationSearchStatus.failure,
          errorMessage: '검색 중 오류가 발생했습니다',
          isSearching: false,
          hasSearched: true,
        ),
      );
    }
  }

  Future<void> _onDeleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<NotificationSearchState> emit,
  ) async {
    try {
      await _repository.deleteSearchHistory(event.keyword);
      final updatedHistory = await _repository.getSearchHistory();

      emit(state.copyWith(searchHistory: updatedHistory));
    } catch (e) {
      emit(state.copyWith(errorMessage: '검색 기록 삭제에 실패했습니다'));
    }
  }

  Future<void> _onClearAllSearchHistory(
    ClearAllSearchHistory event,
    Emitter<NotificationSearchState> emit,
  ) async {
    try {
      await _repository.clearAllSearchHistory();

      emit(state.copyWith(searchHistory: []));
    } catch (e) {
      emit(state.copyWith(errorMessage: '전체 검색 기록 삭제에 실패했습니다'));
    }
  }

  void _onClearSearchResults(
    ClearSearchResults event,
    Emitter<NotificationSearchState> emit,
  ) {
    emit(
      state.copyWith(
        notifications: [],
        hasSearched: false,
        currentKeyword: '',
        errorMessage: null,
      ),
    );
  }

  void _onUpdateSearchKeyword(
    UpdateSearchKeyword event,
    Emitter<NotificationSearchState> emit,
  ) {
    emit(state.copyWith(currentKeyword: event.keyword));

    if (event.keyword.trim().isEmpty) {
      emit(state.copyWith(notifications: [], hasSearched: false));
    }
  }
}
