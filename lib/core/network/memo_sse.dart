import 'dart:async';
import 'package:flutter/foundation.dart'; // ValueNotifier 임포트
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';

class MemoSSEManager {
  final String baseUrl = "https://52.78.13.49.nip.io:8443";
  final String lectureId;
  final String token = "";

  StreamSubscription<SSEModel>? _subscription;

  // 기존 String? 대신 ValueNotifier 사용
  final ValueNotifier<String?> currentMemoNotifier = ValueNotifier(null);

  MemoSSEManager({required this.lectureId});

  void start() {
    final url = "$baseUrl/subscribe/lectures/$lectureId/memos";

    _subscription =
        SSEClient.subscribeToSSE(
          url: url,
          method: SSERequestType.GET,
          header: {'Authorization': 'Bearer $token'},
        ).listen(
          (event) {
            _handleEvent(event);
          },
          onError: (error) {
            print("❌ SSE Error: $error");
            _reconnect();
          },
          cancelOnError: true,
        );

    print("✅ SSE Started: $url");
  }

  void _handleEvent(SSEModel event) {
    print("📩 SSE Event: ${event.event} → ${event.data}");

    switch (event.event) {
      case "connect":
        print("SSE Connected: ${event.data}");
        break;

      case "new_memo":
        currentMemoNotifier.value = event.data; // 여기서 상태 업데이트
        print("📝 Current memo updated: ${currentMemoNotifier.value}");
        break;

      default:
        print("⚠️ Unknown event: ${event.event}");
    }
  }

  void _reconnect() {
    Future.delayed(const Duration(seconds: 5), () {
      print("🔄 Reconnecting SSE...");
      start();
    });
  }

  void stop() {
    _subscription?.cancel();
    print("🛑 SSE Stopped");
  }

  // ValueNotifier 접근용 getter (필요하면)
  String? get currentMemo => currentMemoNotifier.value;

  void clearCurrentMemo() {
    currentMemoNotifier.value = null;
    print("♻️ Current memo cleared");
  }

  // 꼭 dispose 해줘야 함
  void dispose() {
    _subscription?.cancel();
    currentMemoNotifier.dispose();
  }
}
