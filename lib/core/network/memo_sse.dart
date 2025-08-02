import 'dart:async';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/core/constants/api.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/core/network/api_client.dart';

class MemoSSEManager {
  final String baseUrl = "https://52.78.13.49.nip.io:8443";
  final String lectureId;
  final GoRouter router;
  String? _token;

  StreamSubscription<SSEModel>? _subscription;
  final ValueNotifier<bool> memoStateNotifier = ValueNotifier(false);
  final ValueNotifier<String?> memoIdNotifier = ValueNotifier(null); // 메모 ID 추가
  Timer? _reconnectTimer;
  bool _isDisposed = false;
  bool _isPaused = false;
  bool _isReissuingToken = false;

  MemoSSEManager({required this.lectureId, required this.router});

  Future<void> initialize() async {
    if (_isDisposed || _isPaused) return;
    _token = await AuthStorage.getAccessToken();
    print('🔧 [SSE-INIT] Token loaded: ${_token?.substring(0, 20)}...');
  }

  Future<void> start() async {
    if (_isDisposed) return;

    // 토큰이 없으면 먼저 가져오기
    if (_token == null) {
      await initialize();
    }

    // 토큰이 여전히 없으면 로그인으로 리다이렉트
    if (_token == null) {
      print('❌ [SSE] No token available, redirecting to login');
      router.go('/login');
      return;
    }

    // 기존 연결이 있으면 정리
    await stop();

    final url = "$baseUrl/subscribe/lectures/$lectureId/memos";

    try {
      _subscription =
          SSEClient.subscribeToSSE(
            url: url,
            method: SSERequestType.GET,
            header: {'Authorization': 'Bearer $_token'},
          ).listen(
            (event) {
              if (!_isDisposed && !_isPaused) {
                _handleEvent(event);
              }
            },
            onError: (error) {
              print("❌ [SSE] Error: $error");
              if (!_isDisposed && !_isPaused) {
                _handleSSEError(error);
              }
            },
            cancelOnError: false,
          );

      print("✅ [SSE] Started: $url");
      print("🔑 [SSE] Using token: ${_token?.substring(0, 20)}...");
    } catch (e) {
      print("❌ [SSE] Failed to start: $e");
      if (!_isDisposed && !_isPaused) {
        _handleSSEError(e);
      }
    }
  }

  void _handleEvent(SSEModel event) {
    if (_isDisposed || _isPaused) return;

    print("📩 [SSE] Event: ${event.event} → ${event.data}");

    switch (event.event) {
      case "connect":
        print("✅ [SSE] Connected: ${event.data}");
        _handleNewMemoEvent(event.data);
        break;

      case "new_memo":
        _handleNewMemoEvent(event.data);
        break;

      default:
        print("⚠️ [SSE] Unknown event: ${event.event}");
    }
  }

  void _handleNewMemoEvent(String? data) {
    if (data != null && data.isNotEmpty) {
      // data에 메모 ID가 직접 들어있음 (예: "103")
      try {
        final memoId = data.trim();
        memoStateNotifier.value = true;
        memoIdNotifier.value = memoId;
        print("📝 [SSE] New memo detected - ID: $memoId");
      } catch (e) {
        print("❌ [SSE] Error parsing memo ID: $e");
        memoStateNotifier.value = true;
        memoIdNotifier.value = data.trim();
      }
    } else {
      // 데이터가 없으면 메모 없음으로 처리
      memoStateNotifier.value = false;
      memoIdNotifier.value = null;
      print("📝 [SSE] No memo data");
    }
  }

  void _handleSSEError(dynamic error) {
    if (_isDisposed || _isPaused) return;

    print("🔍 [SSE-ERROR] Analyzing error: $error");

    // 401 에러 또는 인증 관련 에러 확인
    if (_isAuthenticationError(error)) {
      print(
        "🔄 [SSE] Authentication error detected, attempting token reissue...",
      );
      _handleAuthenticationError();
    } else {
      // 일반적인 연결 에러는 재연결 시도
      //_scheduleReconnect();
    }
  }

  bool _isAuthenticationError(dynamic error) {
    final errorString = error.toString().toLowerCase();
    return errorString.contains('401') ||
        errorString.contains('unauthorized') ||
        errorString.contains('authentication') ||
        errorString.contains('token');
  }

  Future<void> _handleAuthenticationError() async {
    if (_isReissuingToken || _isDisposed || _isPaused) return;

    _isReissuingToken = true;

    try {
      print('🔄 [SSE-TOKEN] Attempting token reissue...');

      // ApiClient의 토큰 재발급 로직을 재사용
      final success = await _reissueTokenForSSE();

      if (success) {
        print('✅ [SSE-TOKEN] Token reissue successful, restarting SSE...');

        // 토큰 업데이트 후 SSE 재시작
        await _updateTokenAndRestart();
      } else {
        print('❌ [SSE-TOKEN] Token reissue failed, redirecting to login...');

        // 토큰 재발급 실패 시 로그아웃 처리
        await _handleLogout();
      }
    } catch (e) {
      print('❌ [SSE-TOKEN] Error during token reissue: $e');
      await _handleLogout();
    } finally {
      _isReissuingToken = false;
    }
  }

  Future<bool> _reissueTokenForSSE() async {
    try {
      final refreshToken = await AuthStorage.getRefreshToken();

      if (refreshToken == null) {
        print('❌ [SSE-TOKEN] No refresh token available');
        return false;
      }

      print('📤 [SSE-TOKEN] Calling reissue API...');
      print('   Using refresh token: ${refreshToken.substring(0, 20)}...');

      // ApiClient의 dio 인스턴스를 사용하여 토큰 재발급
      final tokenDio = Dio(
        BaseOptions(
          baseUrl: API.hostConnect,
          connectTimeout: const Duration(seconds: 5),
          receiveTimeout: const Duration(seconds: 5),
        ),
      );

      final response = await tokenDio.post(
        '/auth/reissue',
        options: Options(headers: {'Authorization': 'Bearer $refreshToken'}),
      );

      print('📥 [SSE-TOKEN] Reissue response: ${response.statusCode}');
      print('   Response data: ${response.data}');

      if (response.statusCode == 200 &&
          response.data['status'] == 'success' &&
          response.data['data'] != null) {
        final data = response.data['data'];
        final newAccessToken = data['accessToken'];
        final newRefreshToken = data['refreshToken'];

        if (newAccessToken == null || newRefreshToken == null) {
          print('❌ [SSE-TOKEN] Missing tokens in response');
          return false;
        }

        print('✅ [SSE-TOKEN] New tokens received');
        print('   New Access Token: ${newAccessToken.substring(0, 20)}...');
        print('   New Refresh Token: ${newRefreshToken.substring(0, 20)}...');

        // 토큰 저장 (이때 ApiClient도 자동으로 업데이트됨)
        await AuthStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );

        return true;
      } else {
        print('❌ [SSE-TOKEN] Invalid reissue response: ${response.data}');
        return false;
      }
    } catch (e) {
      print('❌ [SSE-TOKEN] Reissue error: $e');
      return false;
    }
  }

  Future<void> _updateTokenAndRestart() async {
    try {
      // 스토리지에서 새로운 토큰 로드
      _token = await AuthStorage.getAccessToken();
      print('🔄 [SSE-TOKEN] Token updated: ${_token?.substring(0, 20)}...');

      // SSE 연결 재시작
      await start();
    } catch (e) {
      print('❌ [SSE-TOKEN] Error updating token and restarting: $e');
      _scheduleReconnect();
    }
  }

  Future<void> _handleLogout() async {
    try {
      print('🚪 [SSE-LOGOUT] Starting logout process...');

      // SSE 연결 중단
      await stop();

      // 토큰 클리어
      await AuthStorage.clear();

      // 로그인 페이지로 이동
      router.go('/login');

      print('✅ [SSE-LOGOUT] Logout completed');
    } catch (e) {
      print('❌ [SSE-LOGOUT] Error during logout: $e');
      // 에러가 있어도 로그인 페이지로 이동
      router.go('/login');
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed || _isPaused) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed && !_isPaused) {
        print("🔄 [SSE] Reconnecting...");
        start();
      }
    });
  }

  // 토큰이 외부에서 업데이트되었을 때 호출할 메서드
  Future<void> onTokenUpdated() async {
    if (_isDisposed || _isPaused) return;

    print('🔄 [SSE] Token updated externally, refreshing connection...');

    // 새 토큰 로드
    _token = await AuthStorage.getAccessToken();
    print('🔑 [SSE] New token loaded: ${_token?.substring(0, 20)}...');

    // SSE 연결 재시작
    await start();
  }

  // 일시정지 기능
  void pause() {
    if (_isDisposed) return;

    _isPaused = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    print("⏸️ [SSE] Paused");
  }

  // 재시작 기능
  Future<void> resume() async {
    if (_isDisposed) return;

    _isPaused = false;
    await start();
    print("▶️ [SSE] Resumed");
  }

  Future<void> stop() async {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    print("🛑 [SSE] Stopped");
  }

  // Getters
  bool get currentMemoState => memoStateNotifier.value;
  String? get currentMemoId => memoIdNotifier.value; // 메모 ID getter 추가
  bool get isPaused => _isPaused;
  bool get isReissuingToken => _isReissuingToken;

  void updateMemoState(bool state, {String? memoId}) {
    if (!_isDisposed) {
      memoStateNotifier.value = state;
      if (state && memoId != null) {
        memoIdNotifier.value = memoId;
      } else if (!state) {
        memoIdNotifier.value = null; // 메모가 없으면 ID도 null로 설정
      }
      print("📝 [SSE] Memo state manually updated: $state, ID: $memoId");
    }
  }

  // 메모 ID를 수동으로 업데이트하는 메서드 추가
  void updateMemoId(String? memoId) {
    if (!_isDisposed) {
      memoIdNotifier.value = memoId;
      print("📝 [SSE] Memo ID manually updated: $memoId");
    }
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    memoStateNotifier.dispose();
    memoIdNotifier.dispose(); // 메모 ID notifier도 dispose
    print("🗑️ [SSE] Manager disposed");
  }
}
