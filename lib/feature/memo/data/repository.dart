import 'package:ormee_app/feature/memo/data/remote_datasource.dart';
import 'package:ormee_app/feature/memo/data/model.dart';

abstract class MemoRepository {
  Future<MemoModel> getMemoDetail(int memoId);
  Future<void> submitMemo(int memoId, MemoModel memo);
  Future<List<MemoModel>> getMemoList(int lectureId);
}

class MemoRepositoryImpl implements MemoRepository {
  final MemoRemoteDataSource _remoteDataSource;

  MemoRepositoryImpl({required MemoRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  @override
  Future<MemoModel> getMemoDetail(int memoId) async {
    try {
      return await _remoteDataSource.fetchMemoDetail(memoId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> submitMemo(int memoId, MemoModel memo) async {
    try {
      await _remoteDataSource.postMemo(memoId, memo);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<MemoModel>> getMemoList(int lectureId) async {
    try {
      return await _remoteDataSource.fetchMemoList(lectureId);
    } catch (e) {
      rethrow;
    }
  }
}
