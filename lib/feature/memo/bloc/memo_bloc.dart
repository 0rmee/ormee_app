import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/memo/bloc/memo_event.dart';
import 'package:ormee_app/feature/memo/bloc/memo_state.dart';
import 'package:ormee_app/feature/memo/data/repository.dart';

class MemoBloc extends Bloc<MemoEvent, MemoState> {
  final MemoRepository _repository;

  MemoBloc({required MemoRepository repository})
    : _repository = repository,
      super(MemoInitial()) {
    on<LoadMemoDetail>(_onLoadMemoDetail);
    on<SubmitMemo>(_onSubmitMemo);
    on<LoadMemoList>(_onLoadMemoList);
    on<RefreshMemoDetail>(_onRefreshMemoDetail);
    on<RefreshMemoList>(_onRefreshMemoList);
  }

  Future<void> _onLoadMemoDetail(
    LoadMemoDetail event,
    Emitter<MemoState> emit,
  ) async {
    emit(MemoLoading());
    try {
      final memo = await _repository.getMemoDetail(event.memoId);
      emit(MemoDetailLoaded(memo: memo));
    } catch (e) {
      emit(MemoDetailError(message: e.toString()));
    }
  }

  Future<void> _onSubmitMemo(SubmitMemo event, Emitter<MemoState> emit) async {
    emit(MemoSubmitting());
    try {
      await _repository.submitMemo(event.memoId, event.context);
      emit(const MemoSubmitSuccess(message: '쪽지가 성공적으로 제출되었습니다.'));
    } catch (e) {
      emit(MemoSubmitError(message: e.toString()));
    }
  }

  Future<void> _onLoadMemoList(
    LoadMemoList event,
    Emitter<MemoState> emit,
  ) async {
    emit(MemoLoading());
    try {
      final memoList = await _repository.getMemoList(event.lectureId);
      emit(MemoListLoaded(memoList: memoList));
    } catch (e) {
      emit(MemoListError(message: e.toString()));
    }
  }

  Future<void> _onRefreshMemoDetail(
    RefreshMemoDetail event,
    Emitter<MemoState> emit,
  ) async {
    try {
      final memo = await _repository.getMemoDetail(event.memoId);
      emit(MemoDetailLoaded(memo: memo));
    } catch (e) {
      emit(MemoDetailError(message: e.toString()));
    }
  }

  Future<void> _onRefreshMemoList(
    RefreshMemoList event,
    Emitter<MemoState> emit,
  ) async {
    try {
      final memoList = await _repository.getMemoList(event.lectureId);
      emit(MemoListLoaded(memoList: memoList));
    } catch (e) {
      emit(MemoListError(message: e.toString()));
    }
  }
}
