import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/memo/data/model.dart';

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
  final MemoModel memo;

  const SubmitMemo({required this.memoId, required this.memo});

  @override
  List<Object?> get props => [memoId, memo];
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
