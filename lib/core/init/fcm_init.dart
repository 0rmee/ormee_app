import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:ormee_app/core/network/fcm_token_datasource.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  print('Handling a background message: ${message.messageId}');
  print('Background message data: ${message.data}');

  if (message.notification != null) {
    print('Background message notification: ${message.notification}');
  }
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // 1. 먼저 권한 요청
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  print('User granted permission: ${settings.authorizationStatus}');

  // 2. 권한이 승인된 경우에만 리스너 설정
  if (settings.authorizationStatus == AuthorizationStatus.authorized ||
      settings.authorizationStatus == AuthorizationStatus.provisional) {
    // 백그라운드 메시지 핸들러 설정
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 포그라운드 메시지 처리
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message data: ${message.data}');

      if (message.notification != null) {
        print('Message also contained a notification: ${message.notification}');
        // 여기서 로컬 알림 표시하거나 UI 업데이트
        // 예: showDialog, ScaffoldMessenger.showSnackBar 등
      }
    });

    // 앱이 종료된 상태에서 알림을 탭하여 앱을 실행한 경우
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      print('Message data: ${message.data}');

      // 특정 화면으로 네비게이션 등의 처리
      // 예: Navigator.pushNamed(context, '/specific-page');
    });

    // 앱이 완전히 종료된 상태에서 알림으로 앱을 시작한 경우 확인
    RemoteMessage? initialMessage = await messaging.getInitialMessage();
    if (initialMessage != null) {
      print('App opened from terminated state via notification');
      print('Initial message data: ${initialMessage.data}');
      // 특정 화면으로 네비게이션 등의 처리
    }

    // FCM 토큰 가져오기 (서버에 전송하기 위해)
    String? token = await messaging.getToken();
    if (token != null) {
      print('FCM Token: $token');
      // 서버에 토큰 전송
      await sendTokenToServer(token);
    } else {
      print('FCM 토큰을 가져올 수 없습니다');
    }
    // 토큰이 갱신될 때마다 호출되는 리스너
    messaging.onTokenRefresh.listen((String token) async {
      print('FCM Token refreshed: $token');
      // 새로운 토큰을 서버에 전송
      await sendTokenToServer(token);
    });
  } else {
    print('User declined or has not accepted permission');
  }
}
