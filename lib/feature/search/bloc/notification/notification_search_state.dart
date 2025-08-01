import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/search/data/notification/model.dart';

enum NotificationSearchStatus { initial, loading, success, failure }

class NotificationSearchState extends Equatable {
  final NotificationSearchStatus status;
  final List<Notification> notifications;
  final List<SearchHistory> searchHistory;
  final String currentKeyword;
  final String? errorMessage;
  final bool isSearching;
  final bool hasSearched;

  const NotificationSearchState({
    this.status = NotificationSearchStatus.initial,
    this.notifications = const [],
    this.searchHistory = const [],
    this.currentKeyword = '',
    this.errorMessage,
    this.isSearching = false,
    this.hasSearched = false,
  });

  NotificationSearchState copyWith({
    NotificationSearchStatus? status,
    List<Notification>? notifications, // 여기 수정
    List<SearchHistory>? searchHistory,
    String? currentKeyword,
    String? errorMessage,
    bool? isSearching,
    bool? hasSearched,
  }) {
    return NotificationSearchState(
      status: status ?? this.status,
      notifications: notifications ?? this.notifications,
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
    notifications,
    searchHistory,
    currentKeyword,
    errorMessage,
    isSearching,
    hasSearched,
  ];
}
