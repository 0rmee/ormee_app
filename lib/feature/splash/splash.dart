import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    const minSplashDuration = Duration(seconds: 2);
    final startTime = DateTime.now();

    // 토큰 불러오기
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    // 최소 스플래시 유지시간 계산
    final elapsed = DateTime.now().difference(startTime);
    final waitTime = minSplashDuration - elapsed;
    if (waitTime > Duration.zero) {
      await Future.delayed(waitTime);
    }

    if (accessToken != null && refreshToken != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset("assets/images/logo.svg"),
            const SizedBox(height: 16),
            Body2RegularNormal14(text: "하나로 끝내는 수업 관리의 새로운 기준"),
          ],
        ), // 혹은 로고 이미지 등
      ),
    );
  }
}
