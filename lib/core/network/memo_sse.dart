import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:ormee_app/feature/auth/token/update.dart';

class MemoSSEManager {
  final String baseUrl = "https://52.78.13.49.nip.io:8443";
  final String lectureId;
  String? _token;

  StreamSubscription<SSEModel>? _subscription;
  final ValueNotifier<bool> memoStateNotifier = ValueNotifier(
    false,
  ); // bool로 변경
  Timer? _reconnectTimer;
  bool _isDisposed = false;

  MemoSSEManager({required this.lectureId});

  Future<void> initialize() async {
    if (_isDisposed) return;
    _token = await AuthStorage.getAccessToken();
  }

  Future<void> start() async {
    if (_isDisposed) return;

    // 토큰이 없으면 먼저 가져오기
    if (_token == null) {
      await initialize();
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
              if (!_isDisposed) {
                _handleEvent(event);
              }
            },
            onError: (error) {
              print("❌ SSE Error: $error");
              if (!_isDisposed) {
                _scheduleReconnect();
              }
            },
            cancelOnError: true,
          );

      print("✅ SSE Started: $url");
    } catch (e) {
      print("❌ Failed to start SSE: $e");
      if (!_isDisposed) {
        _scheduleReconnect();
      }
    }
  }

  void _handleEvent(SSEModel event) {
    if (_isDisposed) return;

    print("📩 SSE Event: ${event.event} → ${event.data}");

    switch (event.event) {
      case "connect":
        print("SSE Connected: ${event.data}");
        break;

      case "new_memo":
        // 문자열을 bool로 변환하여 상태 업데이트
        final hasMemo = event.data?.toLowerCase() == 'true';
        memoStateNotifier.value = hasMemo;
        print("📝 Memo state updated: $hasMemo");
        break;

      default:
        print("⚠️ Unknown event: ${event.event}");
    }
  }

  void _scheduleReconnect() {
    if (_isDisposed) return;

    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 5), () {
      if (!_isDisposed) {
        print("🔄 Reconnecting SSE...");
        start();
      }
    });
  }

  Future<void> stop() async {
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    _subscription = null;
    print("🛑 SSE Stopped");
  }

  // getter 추가
  bool get currentMemoState => memoStateNotifier.value;

  void updateMemoState(bool state) {
    if (!_isDisposed) {
      memoStateNotifier.value = state;
      print("📝 Memo state manually updated: $state");
    }
  }

  void dispose() {
    _isDisposed = true;
    _reconnectTimer?.cancel();
    _subscription?.cancel();
    memoStateNotifier.dispose();
    print("🗑️ MemoSSEManager disposed");
  }
}
