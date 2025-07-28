import 'package:equatable/equatable.dart';
import 'package:ormee_app/feature/memo/data/model.dart';

abstract class MemoState extends Equatable {
  const MemoState();

  @override
  List<Object?> get props => [];
}

class MemoInitial extends MemoState {}

class MemoLoading extends MemoState {}

class MemoDetailLoaded extends MemoState {
  final MemoModel memo;

  const MemoDetailLoaded({required this.memo});

  @override
  List<Object?> get props => [memo];
}

class MemoListLoaded extends MemoState {
  final List<MemoModel> memoList;

  const MemoListLoaded({required this.memoList});

  @override
  List<Object?> get props => [memoList];
}

class MemoSubmitSuccess extends MemoState {
  final String message;

  const MemoSubmitSuccess({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemoSubmitting extends MemoState {}

class MemoError extends MemoState {
  final String message;

  const MemoError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemoDetailError extends MemoState {
  final String message;

  const MemoDetailError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemoListError extends MemoState {
  final String message;

  const MemoListError({required this.message});

  @override
  List<Object?> get props => [message];
}

class MemoSubmitError extends MemoState {
  final String message;

  const MemoSubmitError({required this.message});

  @override
  List<Object?> get props => [message];
}
