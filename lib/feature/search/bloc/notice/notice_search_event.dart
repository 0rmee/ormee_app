import 'package:equatable/equatable.dart';

abstract class NoticeSearchEvent extends Equatable {
  const NoticeSearchEvent();

  @override
  List<Object?> get props => [];
}

class LoadSearchHistory extends NoticeSearchEvent {
  const LoadSearchHistory();
}

class SearchNotices extends NoticeSearchEvent {
  final String keyword;
  final int lectureId;

  const SearchNotices({required this.keyword, required this.lectureId});

  @override
  List<Object?> get props => [keyword, lectureId];
}

class SearchFromHistory extends NoticeSearchEvent {
  final String keyword;
  final int lectureId;

  const SearchFromHistory({required this.keyword, required this.lectureId});

  @override
  List<Object?> get props => [keyword, lectureId];
}

class DeleteSearchHistory extends NoticeSearchEvent {
  final String keyword;

  const DeleteSearchHistory({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}

class ClearAllSearchHistory extends NoticeSearchEvent {
  const ClearAllSearchHistory();
}

class ClearSearchResults extends NoticeSearchEvent {
  const ClearSearchResults();
}

class UpdateSearchKeyword extends NoticeSearchEvent {
  final String keyword;

  const UpdateSearchKeyword({required this.keyword});

  @override
  List<Object?> get props => [keyword];
}
