import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:ormee_app/app/router/app_router.dart';
import 'package:ormee_app/core/network/api_client.dart';

// 토큰 업데이트 콜백 타입 정의
typedef TokenUpdateCallback = Future<void> Function();

class AuthStorage {
  static const _accessTokenKey = 'ACCESS_TOKEN';
  static const _refreshTokenKey = 'REFRESH_TOKEN';

  static final _storage = FlutterSecureStorage();

  // SSE 매니저들의 토큰 업데이트 콜백을 저장
  static final List<TokenUpdateCallback> _tokenUpdateCallbacks = [];

  // SSE 매니저 등록
  static void registerTokenUpdateCallback(TokenUpdateCallback callback) {
    print('📝 [AUTH-STORAGE] Registering token update callback');
    _tokenUpdateCallbacks.add(callback);
  }

  // SSE 매니저 등록 해제
  static void unregisterTokenUpdateCallback(TokenUpdateCallback callback) {
    print('📝 [AUTH-STORAGE] Unregistering token update callback');
    _tokenUpdateCallbacks.remove(callback);
  }

  // 모든 등록된 콜백에 토큰 업데이트 알림
  static Future<void> _notifyTokenUpdate() async {
    print(
      '📢 [AUTH-STORAGE] Notifying ${_tokenUpdateCallbacks.length} callbacks of token update',
    );

    final futures = _tokenUpdateCallbacks.map((callback) async {
      try {
        await callback();
      } catch (e) {
        print('❌ [AUTH-STORAGE] Error in token update callback: $e');
      }
    });

    await Future.wait(futures);
    print('✅ [AUTH-STORAGE] All token update callbacks completed');
  }

  // 토큰 저장
  static Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    print('💾 [AUTH-STORAGE] Saving tokens to secure storage');
    print('   Access Token: $accessToken');
    print('   Refresh Token: $refreshToken');

    await _storage.write(key: _accessTokenKey, value: accessToken);
    await _storage.write(key: _refreshTokenKey, value: refreshToken);
    print('✅ [AUTH-STORAGE] Tokens saved successfully');

    // ApiClient 재초기화
    await ApiClient.instance.reinitialize(AppRouter.router);

    // SSE 매니저들에게 토큰 업데이트 알림
    await _notifyTokenUpdate();
  }

  // 토큰 가져오기
  static Future<String?> getAccessToken() async {
    try {
      return await _storage.read(key: _accessTokenKey);
    } catch (e) {
      print('❌ [AUTH-STORAGE] Failed to read access token: $e');
      if (e.toString().contains('BAD_DECRYPT')) {
        await clear();
      }
      return null;
    }
  }

  static Future<String?> getRefreshToken() async {
    try {
      return await _storage.read(key: _refreshTokenKey);
    } catch (e) {
      print('❌ [AUTH-STORAGE] Failed to read refresh token: $e');
      if (e.toString().contains('BAD_DECRYPT')) {
        await clear();
      }
      return null;
    }
  }

  // 전체 삭제
  static Future<void> clear() async {
    print('🗑️ [AUTH-STORAGE] Clearing all tokens');

    await _storage.delete(key: _accessTokenKey);
    await _storage.delete(key: _refreshTokenKey);
    await _storage.deleteAll(); // 혹시 모르니 전체 삭제

    // 콜백 리스트도 클리어 (로그아웃 시)
    _tokenUpdateCallbacks.clear();

    print('✅ [AUTH-STORAGE] All tokens cleared');
  }

  // 디버깅용: 현재 등록된 콜백 수 확인
  static int get callbackCount => _tokenUpdateCallbacks.length;
}
