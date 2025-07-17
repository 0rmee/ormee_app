import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthStorage {
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  static final _storage = FlutterSecureStorage();

  // 토큰 저장
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
  }

  // 토큰 가져오기
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      print('Failed to read access token: $e');
      if (e.toString().contains('BAD_DECRYPT')) {
        await clear();
      }
      return null;
    }
  }

  static Future<String?> getRefreshToken() async {
    return await _storage.read(key: _refreshTokenKey);
  }

  // 전체 삭제
  static Future<void> clear() async {
    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.deleteAll(); // 혹시 모르니 전체 삭제
  }
}
