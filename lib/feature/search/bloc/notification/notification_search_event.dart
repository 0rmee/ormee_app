import 'package:equatable/equatable.dart';

abstract class NotificationSearchEvent extends Equatable {
  const NotificationSearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadSearchHistory extends NotificationSearchEvent {
  const LoadSearchHistory();
}

class SearchNotifications extends NotificationSearchEvent {
  final String keyword;

  const SearchNotifications({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class SearchFromHistory extends NotificationSearchEvent {
  final String keyword;

  const SearchFromHistory({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class DeleteSearchHistory extends NotificationSearchEvent {
  final String keyword;

  const DeleteSearchHistory({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ClearAllSearchHistory extends NotificationSearchEvent {
  const ClearAllSearchHistory();
}

class ClearSearchResults extends NotificationSearchEvent {
  const ClearSearchResults();
}

class UpdateSearchKeyword extends NotificationSearchEvent {
  final String keyword;

  const UpdateSearchKeyword({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
