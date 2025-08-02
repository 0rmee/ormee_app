import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';

class ApiClient {
  // 싱글턴
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: API.hostConnect,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // 요청 전 디버깅 정보 출력
          _logRequest(options);

          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
            print(
              '🔑 [TOKEN-CHECK] Using access token: ${_accessToken!.substring(0, 20)}...',
            );
          } else {
            print('⚠️ [TOKEN-CHECK] No access token available!');
          }
          return handler.next(options);
        },
        onResponse: (response, handler) {
          // 응답 후 디버깅 정보 출력
          _logResponse(response);
          return handler.next(response);
        },
        onError: (error, handler) async {
          // 에러 발생 시 디버깅 정보 출력
          _logError(error);

          if (error.response?.statusCode == 401) {
            print('🔄 [TOKEN] 401 Unauthorized - Attempting token reissue...');
            print(
              '🔍 [DEBUG] Current _accessToken before reissue: ${_accessToken?.substring(0, 20)}...',
            );
            print(
              '🔍 [DEBUG] Current _refreshToken before reissue: ${_refreshToken?.substring(0, 20)}...',
            );

            final reissueSuccess = await reissueToken();

            if (reissueSuccess) {
              print('✅ [TOKEN] Token reissue successful, retrying request...');
              print(
                '🔍 [DEBUG] Current _accessToken after reissue: ${_accessToken?.substring(0, 20)}...',
              );
              print(
                '🔍 [DEBUG] Current _refreshToken after reissue: ${_refreshToken?.substring(0, 20)}...',
              );

              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $_accessToken';

              print(
                '🔍 [DEBUG] Authorization header being set: Bearer ${_accessToken?.substring(0, 20)}...',
              );

              // 재시도 요청 로그
              print('🔄 [RETRY] Retrying request with new token...');
              _logRequest(opts, isRetry: true);

              try {
                final cloneReq = await _dio.fetch(opts);
                print('✅ [RETRY] Retry request successful');
                _logResponse(cloneReq);
                return handler.resolve(cloneReq);
              } catch (retryError) {
                print('❌ [RETRY] Retry request failed: $retryError');
                return handler.next(
                  DioException(requestOptions: opts, error: retryError),
                );
              }
            } else {
              print('❌ [TOKEN] Token reissue failed, calling logout...');
              _logDetailedAuthError(error);

              // 로그아웃 처리를 비동기로 실행
              Future.microtask(() => _onLogout?.call());

              // 인증 실패 에러를 반환
              return handler.next(
                DioException(
                  requestOptions: error.requestOptions,
                  response: error.response,
                  type: DioExceptionType.badResponse,
                  error: 'Authentication failed - token reissue unsuccessful',
                ),
              );
            }
          }

          return handler.next(error);
        },
      ),
    );
  }

  static final ApiClient instance = ApiClient._internal();

  late Dio _dio;

  String? _accessToken;
  String? _refreshToken;
  bool _isReissuingToken = false;

  VoidCallback? _onLogout;

  void initialize({
    required String accessToken,
    required String refreshToken,
    required VoidCallback onLogout,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _onLogout = onLogout;

    print('🔧 [INIT] ApiClient initialized');
    print('   Access Token: ${accessToken}');
    print('   Refresh Token: ${refreshToken}');
  }

  Dio get dio => _dio;

  // 현재 토큰 상태 확인 메서드
  void printCurrentTokens() {
    print('🔍 [TOKENS] Current token status:');
    print('   Access Token: ${_accessToken ?? "none"}');
    print('   Refresh Token: ${_refreshToken ?? "none"}');
    print('   Is reissuing: $_isReissuingToken');
  }

  // 토큰 업데이트 메서드 (스토리지에서 로드)
  Future<void> updateTokensFromStorage() async {
    try {
      print('🔄 [TOKEN-UPDATE] Loading tokens from storage...');

      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        print('✅ [TOKEN-UPDATE] Tokens loaded from storage');
        print('   Access Token: ${accessToken}');
        print('   Refresh Token: ${refreshToken}');

        _accessToken = accessToken;
        _refreshToken = refreshToken;

        print('✅ [TOKEN-UPDATE] ApiClient tokens updated');
      } else {
        print('⚠️ [TOKEN-UPDATE] No tokens found in storage');
        _accessToken = null;
        _refreshToken = null;
      }
    } catch (e) {
      print('❌ [TOKEN-UPDATE] Error updating tokens from storage: $e');
      rethrow;
    }
  }

  // 간편한 재초기화 메서드
  Future<void> reinitialize(GoRouter router) async {
    try {
      print('🔄 [REINIT] Reinitializing ApiClient...');

      final accessToken = await AuthStorage.getAccessToken();
      final refreshToken = await AuthStorage.getRefreshToken();

      if (accessToken != null && refreshToken != null) {
        initialize(
          accessToken: accessToken,
          refreshToken: refreshToken,
          onLogout: () async {
            print('🚪 [LOGOUT] Clearing tokens and redirecting to login');
            await AuthStorage.clear();
            router.go('/login');
          },
        );
        print('✅ [REINIT] ApiClient reinitialized successfully');
      } else {
        print('⚠️ [REINIT] No tokens available for reinitialization');
        throw Exception('No tokens available for reinitialization');
      }
    } catch (e) {
      print('❌ [REINIT] Error during reinitialization: $e');
      rethrow;
    }
  }

  // 요청 로깅
  void _logRequest(RequestOptions options, {bool isRetry = false}) {
    final prefix = isRetry ? '🔄 [RETRY-REQ]' : '📤 [REQUEST]';
    print('$prefix ${options.method.toUpperCase()} ${options.uri}');
    print('   Base URL: ${options.baseUrl}');
    print('   Path: ${options.path}');

    if (options.queryParameters.isNotEmpty) {
      print('   Query Params: ${options.queryParameters}');
    }

    print('   Headers:');
    options.headers.forEach((key, value) {
      if (key == 'Authorization') {
        // 토큰의 앞뒤 몇 글자만 표시하여 보안 유지
        final tokenStr = value.toString();
        if (tokenStr.length > 20) {
          final masked =
              '${tokenStr.substring(0, 20)}...${tokenStr.substring(tokenStr.length - 10)}';
          print('     $key: $masked');
        } else {
          print('     $key: $value');
        }
      } else {
        print('     $key: $value');
      }
    });

    if (options.data != null) {
      print('   Body: ${options.data}');
    }

    print('   Connect Timeout: ${options.connectTimeout}');
    print('   Receive Timeout: ${options.receiveTimeout}');
  }

  // 응답 로깅
  void _logResponse(Response response) {
    print('📥 [RESPONSE] ${response.statusCode} ${response.statusMessage}');
    print('   URL: ${response.requestOptions.uri}');
    print('   Headers: ${response.headers.map}');
    print('   Data: ${response.data}');
  }

  // 에러 로깅
  void _logError(DioException error) {
    print('❌ [ERROR] ${error.type}');
    print('   Message: ${error.message}');
    print('   URL: ${error.requestOptions.uri}');
    print('   Method: ${error.requestOptions.method}');
    print('   Status Code: ${error.response?.statusCode}');
    print('   Response Data: ${error.response?.data}');
    print('   Request Headers:');
    error.requestOptions.headers.forEach((key, value) {
      print('     $key: $value');
    });
    if (error.requestOptions.data != null) {
      print('   Request Body: ${error.requestOptions.data}');
    }
  }

  // 인증 에러 상세 로깅
  void _logDetailedAuthError(DioException error) {
    print('🔐 [AUTH-ERROR] Detailed authentication error info:');
    print('   Response status: ${error.response?.statusCode}');
    print('   Response data: ${error.response?.data}');
    print('   Dio error: ${error.error}');
    print('   Request URL: ${error.requestOptions.uri}');
    print('   Request method: ${error.requestOptions.method}');
    print('   Request headers:');
    error.requestOptions.headers.forEach((key, value) {
      print('     $key: $value');
    });
    print('   Request body: ${error.requestOptions.data}');
    print('   Current access token: ${_accessToken?.substring(0, 20)}...');
    print('   Current refresh token: ${_refreshToken?.substring(0, 20)}...');
  }

  // 토큰 삭제 (메모리 + secure storage)
  Future<void> clearTokens() async {
    try {
      print('🗑️ [TOKEN] Clearing tokens...');
      print('   Clearing access token: ${_accessToken?.substring(0, 20)}...');
      print('   Clearing refresh token: ${_refreshToken?.substring(0, 20)}...');

      _accessToken = null;
      _refreshToken = null;
      await AuthStorage.clear();
      print('✅ [TOKEN] Tokens cleared successfully');
    } catch (e) {
      print('❌ [TOKEN] Error clearing tokens: $e');
      rethrow;
    }
  }

  Future<bool> reissueToken() async {
    // 동시성 문제 방지
    if (_isReissuingToken) {
      print('⏳ [TOKEN] Token reissue already in progress, waiting...');
      while (_isReissuingToken) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      print('✅ [TOKEN] Token reissue wait completed, using updated token');
      return _accessToken != null;
    }

    _isReissuingToken = true;

    try {
      print('🔄 [TOKEN] Attempting to reissue token...');
      print('   Using refresh token: ${_refreshToken?.substring(0, 20)}...');

      if (_refreshToken == null) {
        print('❌ [TOKEN] No refresh token available');
        return false;
      }

      // 새로운 Dio 인스턴스를 생성하여 인터셉터 우회
      final tokenDio = Dio(
        BaseOptions(
          baseUrl: API.hostConnect,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final requestUrl = '${API.hostConnect}/auth/reissue';
      final headers = {'Authorization': 'Bearer $_refreshToken'};

      print('📤 [TOKEN-REQ] POST $requestUrl');
      print(
        '   Headers: Authorization: Bearer ${_refreshToken?.substring(0, 20)}...',
      );

      final res = await tokenDio.post(
        '/auth/reissue',
        options: Options(headers: headers),
      );

      print('📥 [TOKEN-RES] ${res.statusCode} ${res.statusMessage}');
      print('   Response data: ${res.data}');

      if (res.statusCode == 200 &&
          res.data['status'] == 'success' &&
          res.data['data'] != null) {
        final data = res.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          print('❌ [TOKEN] Token reissue failed - Missing tokens in response');
          return false;
        }

        print('✅ [TOKEN] New tokens received:');
        print('   New Access Token: ${newAccessToken.substring(0, 20)}...');
        print('   New Refresh Token: ${newRefreshToken.substring(0, 20)}...');

        final oldAccessToken = _accessToken;
        final oldRefreshToken = _refreshToken;

        _accessToken = newAccessToken;
        _refreshToken = newRefreshToken;

        print('🔄 [TOKEN] Tokens updated in memory:');
        print('   Old Access Token: ${oldAccessToken?.substring(0, 20)}...');
        print('   New Access Token: ${_accessToken?.substring(0, 20)}...');

        // secure storage에도 동기화
        try {
          await AuthStorage.saveTokens(
            accessToken: _accessToken!,
            refreshToken: _refreshToken!,
          );
          print('✅ [TOKEN] Tokens saved to secure storage');
        } catch (storageError) {
          print('⚠️ [TOKEN] Failed to save tokens to storage: $storageError');
          // 메모리에는 저장되었으므로 계속 진행
        }

        print('✅ [TOKEN] Token reissue completed successfully');
        return true;
      } else {
        print('❌ [TOKEN] Token reissue failed - Invalid response: ${res.data}');
        return false;
      }
    } catch (e) {
      print('❌ [TOKEN] Token reissue error: $e');
      // DioException인 경우 더 자세한 정보 출력
      if (e is DioException) {
        print('   DioException details:');
        print('     Type: ${e.type}');
        print('     Message: ${e.message}');
        print('     Response: ${e.response?.data}');
        print('     Status Code: ${e.response?.statusCode}');
        print('     Request URL: ${e.requestOptions.uri}');
        print('     Request Headers:');
        e.requestOptions.headers.forEach((key, value) {
          print('       $key: $value');
        });
      }
      return false;
    } finally {
      _isReissuingToken = false;
      print('🔓 [TOKEN] Token reissue lock released');
    }
  }

  // 토큰 수동 업데이트 메서드 (디버깅용)
  void updateTokens({
    required String accessToken,
    required String refreshToken,
  }) {
    print('🔧 [TOKEN] Manual token update:');
    print('   Old Access Token: ${_accessToken?.substring(0, 20)}...');
    print('   New Access Token: ${accessToken.substring(0, 20)}...');

    _accessToken = accessToken;
    _refreshToken = refreshToken;

    print('✅ [TOKEN] Tokens updated manually');
  }

  Future<void> logout() async {
    try {
      print('🚪 [LOGOUT] Starting logout process...');

      // 1. 토큰 삭제 (메모리 + 스토리지)
      await clearTokens();

      // 2. _onLogout 콜백 호출 (화면 이동 + 추가 정리 작업)
      print('🔄 [LOGOUT] Calling logout callback...');
      _onLogout?.call();

      print('✅ [LOGOUT] Logout completed successfully');
    } catch (e) {
      print('❌ [LOGOUT] Error during logout: $e');
      // 에러가 있어도 _onLogout은 호출
      _onLogout?.call();
      rethrow;
    }
  }
}
