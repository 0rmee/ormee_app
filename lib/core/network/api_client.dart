import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';

class ApiClient {
  // 싱글턴
  ApiClient._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: API.hostConnect,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 5),
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_accessToken != null) {
            options.headers['Authorization'] = 'Bearer $_accessToken';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // 에러 로그 출력
          print('API Error: ${error.message}');
          print('Status Code: ${error.response?.statusCode}');
          print('Response Data: ${error.response?.data}');

          if (error.response?.statusCode == 401) {
            print('401 Unauthorized - Attempting token reissue...');

            final reissueSuccess = await _reissueToken();

            if (reissueSuccess) {
              print('Token reissue successful, retrying request...');
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $_accessToken';

              try {
                final cloneReq = await _dio.fetch(opts);
                return handler.resolve(cloneReq);
              } catch (retryError) {
                print('Retry request failed: $retryError');
                return handler.next(
                  DioException(requestOptions: opts, error: retryError),
                );
              }
            } else {
              print('Token reissue failed, calling logout...');
              _onLogout?.call();
              return;
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

  VoidCallback? _onLogout;

  void initialize({
    required String accessToken,
    required String refreshToken,
    required VoidCallback onLogout,
  }) {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _onLogout = onLogout;
  }

  Dio get dio => _dio;

  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    try {
      _accessToken = accessToken;
      _refreshToken = refreshToken;
      await AuthStorage.saveTokens(
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
      print('Tokens saved successfully');
    } catch (e) {
      print('Error saving tokens: $e');
      rethrow; // 에러를 다시 던져서 호출하는 쪽에서도 처리할 수 있도록
    }
  }

  // 토큰 삭제 (메모리 + secure storage)
  Future<void> clearTokens() async {
    try {
      _accessToken = null;
      _refreshToken = null;
      await AuthStorage.clear();
      print('Tokens cleared successfully');
    } catch (e) {
      print('Error clearing tokens: $e');
      rethrow;
    }
  }

  Future<bool> _reissueToken() async {
    try {
      print('Attempting to reissue token...');

      // 새로운 Dio 인스턴스를 생성하여 인터셉터 우회
      final tokenDio = Dio(
        BaseOptions(
          baseUrl: API.hostConnect,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final res = await tokenDio.post(
        '/auth/reissue',
        options: Options(headers: {'Authorization': 'Bearer $_refreshToken'}),
      );

      if (res.statusCode == 200 && res.data['data'] != null) {
        final data = res.data['data'];
        _accessToken = data['accessToken'];
        _refreshToken = data['refreshToken'];

        // secure storage에도 동기화
        await AuthStorage.saveTokens(
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        );

        print('Token reissue completed successfully');
        return true;
      } else {
        print('Token reissue failed - Invalid response: ${res.data}');
        return false;
      }
    } catch (e) {
      print('Token reissue error: $e');
      // DioException인 경우 더 자세한 정보 출력
      if (e is DioException) {
        print('DioException details:');
        print('  Type: ${e.type}');
        print('  Message: ${e.message}');
        print('  Response: ${e.response?.data}');
        print('  Status Code: ${e.response?.statusCode}');
      }
      return false;
    }
  }
}
