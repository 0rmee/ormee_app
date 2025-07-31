import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/search/data/notice/model.dart';

enum NoticeSearchStatus { initial, loading, success, failure }

class NoticeSearchState extends Equatable {
  final NoticeSearchStatus status;
  final List<Notice> notices;
  final List<SearchHistory> searchHistory;
  final String currentKeyword;
  final String? errorMessage;
  final bool isSearching;
  final bool hasSearched;

  const NoticeSearchState({
    this.status = NoticeSearchStatus.initial,
    this.notices = const [],
    this.searchHistory = const [],
    this.currentKeyword = '',
    this.errorMessage,
    this.isSearching = false,
    this.hasSearched = false,
  });

  NoticeSearchState copyWith({
    NoticeSearchStatus? status,
    List<Notice>? notices,
    List<SearchHistory>? searchHistory,
    String? currentKeyword,
    String? errorMessage,
    bool? isSearching,
    bool? hasSearched,
  }) {
    return NoticeSearchState(
      status: status ?? this.status,
      notices: notices ?? this.notices,
      searchHistory: searchHistory ?? this.searchHistory,
      currentKeyword: currentKeyword ?? this.currentKeyword,
      errorMessage: errorMessage ?? this.errorMessage,
      isSearching: isSearching ?? this.isSearching,
      hasSearched: hasSearched ?? this.hasSearched,
    );
  }

  @override
  List<Object?> get props => [
    status,
    notices,
    searchHistory,
    currentKeyword,
    errorMessage,
    isSearching,
    hasSearched,
  ];
}
