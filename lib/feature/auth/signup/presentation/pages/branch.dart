import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/signup/presentation/widgets/signup_button.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class Branch extends StatelessWidget {
  const Branch({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // 로고
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset("assets/images/logo.svg"),
                  SizedBox(height: 16),
                  Body2RegularNormal14(text: "하나로 끝내는 수업 관리의 새로운 기준"),
                ],
              ),
              // 라우팅
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                    onTap: () => context.pushNamed('signup'),
                    child: SignupButton(role: '학생'),
                  ),
                  SizedBox(height: 15),
                  GestureDetector(child: SignupButton(role: '선생님')),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
