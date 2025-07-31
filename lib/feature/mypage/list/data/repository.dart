import 'package:ormee_app/feature/mypage/list/data/remote_datasource.dart';

class MyPageProfileRepository {
  final MyPageProfileRemoteDatasource remoteDataSource;

  MyPageProfileRepository(this.remoteDataSource);

  Future<String> readName() {
    return remoteDataSource.fetchProfile();
  }
}