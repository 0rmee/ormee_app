import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/search/bloc/notice/notice_search_event.dart';
import 'package:ormee_app/feature/search/bloc/notice/notice_search_state.dart';
import 'package:ormee_app/feature/search/data/notice/repository.dart';

class NoticeSearchBloc extends Bloc<NoticeSearchEvent, NoticeSearchState> {
  final NoticeSearchRepository _repository;
  Timer? _debounce;

  NoticeSearchBloc({required NoticeSearchRepository repository})
    : _repository = repository,
      super(const NoticeSearchState()) {
    on<LoadSearchHistory>(_onLoadSearchHistory);
    on<SearchNotices>(_onSearchNotices);
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
    Emitter<NoticeSearchState> emit,
  ) async {
    emit(state.copyWith(status: NoticeSearchStatus.loading));

    try {
      final searchHistory = await _repository.getSearchHistory();
      emit(
        state.copyWith(
          status: NoticeSearchStatus.success,
          searchHistory: searchHistory,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NoticeSearchStatus.failure,
          errorMessage: '검색 기록을 불러오는데 실패했습니다',
        ),
      );
    }
  }

  Future<void> _onSearchNotices(
    SearchNotices event,
    Emitter<NoticeSearchState> emit,
  ) async {
    if (event.keyword.trim().isEmpty) {
      emit(
        state.copyWith(
          notices: [],
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
      final notices = await _repository.searchNotices(
        event.keyword,
        event.lectureId,
      );
      final updatedHistory = await _repository.getSearchHistory();

      emit(
        state.copyWith(
          status: NoticeSearchStatus.success,
          notices: notices,
          searchHistory: updatedHistory,
          isSearching: false,
          hasSearched: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NoticeSearchStatus.failure,
          errorMessage: '검색 중 오류가 발생했습니다',
          isSearching: false,
          hasSearched: true,
        ),
      );
    }
  }

  Future<void> _onSearchFromHistory(
    SearchFromHistory event,
    Emitter<NoticeSearchState> emit,
  ) async {
    emit(
      state.copyWith(
        isSearching: true,
        currentKeyword: event.keyword,
        errorMessage: null,
      ),
    );

    try {
      final notices = await _repository.searchNotices(
        event.keyword,
        event.lectureId,
      );
      final updatedHistory = await _repository.getSearchHistory();

      emit(
        state.copyWith(
          status: NoticeSearchStatus.success,
          notices: notices,
          searchHistory: updatedHistory,
          isSearching: false,
          hasSearched: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: NoticeSearchStatus.failure,
          errorMessage: '검색 중 오류가 발생했습니다',
          isSearching: false,
          hasSearched: true,
        ),
      );
    }
  }

  Future<void> _onDeleteSearchHistory(
    DeleteSearchHistory event,
    Emitter<NoticeSearchState> emit,
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
    Emitter<NoticeSearchState> emit,
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
    Emitter<NoticeSearchState> emit,
  ) {
    emit(
      state.copyWith(
        notices: [],
        hasSearched: false,
        currentKeyword: '',
        errorMessage: null,
      ),
    );
  }

  void _onUpdateSearchKeyword(
    UpdateSearchKeyword event,
    Emitter<NoticeSearchState> emit,
  ) {
    emit(state.copyWith(currentKeyword: event.keyword));

    // 실시간 검색 결과 초기화 (필요한 경우)
    if (event.keyword.trim().isEmpty) {
      emit(state.copyWith(notices: [], hasSearched: false));
    }
  }
}
