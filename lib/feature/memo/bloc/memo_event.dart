import 'package:equatable/equatable.dart';

abstract class MemoEvent extends Equatable {
  const MemoEvent();

  @override
  List<Object?> get props => [];
}

class LoadMemoDetail extends MemoEvent {
  final int memoId;

  const LoadMemoDetail({required this.memoId});

  @override
  List<Object?> get props => [memoId];
}

class SubmitMemo extends MemoEvent {
  final int memoId;
  final String context;

  const SubmitMemo({required this.memoId, required this.context});

  @override
  List<Object?> get props => [memoId, context];
}

class LoadMemoList extends MemoEvent {
  final int lectureId;

  const LoadMemoList({required this.lectureId});

  @override
  List<Object?> get props => [lectureId];
}

class RefreshMemoDetail extends MemoEvent {
  final int memoId;

  const RefreshMemoDetail({required this.memoId});

  @override
  List<Object?> get props => [memoId];
}

class RefreshMemoList extends MemoEvent {
  final int lectureId;

  const RefreshMemoList({required this.lectureId});

  @override
  List<Object?> get props => [lectureId];
}
