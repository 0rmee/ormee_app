// FCM 토큰을 서버에 전송하는 함수
import 'package:ormee_app/core/network/fcm_token_repository.dart';

Future<void> sendTokenToServer(String token) async {
  try {
    final fcmToken = FcmToken();
    await fcmToken.sendToken(token);
    print('FCM 토큰 서버 전송 성공: $token');
  } catch (e) {
    print('FCM 토큰 서버 전송 실패: $e');
    // 선택적: 재시도 로직 추가
    // await Future.delayed(Duration(seconds: 5));
    // await sendTokenToServer(token); // 재시도
  }
}
