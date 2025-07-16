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
        connectTimeout: const Duration(seconds: 5),
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
          if (error.response?.statusCode == 401) {
            final reissueSuccess = await _reissueToken();

            if (reissueSuccess) {
              final opts = error.requestOptions;
              opts.headers['Authorization'] = 'Bearer $_accessToken';
              final cloneReq = await _dio.fetch(opts);
              return handler.resolve(cloneReq);
            } else {
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
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    await AuthStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  // 토큰 삭제 (메모리 + secure storage)
  Future<void> clearTokens() async {
    _accessToken = null;
    _refreshToken = null;
    await AuthStorage.clear();
  }

  Future<bool> _reissueToken() async {
    try {
      final res = await _dio.post(
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

        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
