import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class SignupButton extends StatelessWidget {
  final String role;
  late final Color _textColor;
  late final Color _backGround;
  late final Color _button;

  SignupButton({super.key, required this.role}) {
    // role에 따라 색상 초기화
    _initializeColors();
  }

  void _initializeColors() {
    switch (role) {
      case '학생':
        _textColor = OrmeeColor.white;
        _backGround = OrmeeColor.purple[50]!;
        _button = OrmeeColor.purple[40]!;
        break;
      case '선생님':
        _textColor = OrmeeColor.purple[50]!;
        _backGround = OrmeeColor.gray[20]!;
        _button = OrmeeColor.gray[30]!;
        break;
      default:
        _textColor = Colors.black;
        _backGround = Colors.grey[50]!;
        _button = Colors.grey[400]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 110,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: _backGround,
      ),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Headline1Bold18(text: role, color: _textColor),
                SizedBox(width: 3),
                Label1Regular14(text: "으로 가입", color: _textColor),
              ],
            ),
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(25),
                color: _button,
              ),
              child: Center(
                child: SvgPicture.asset(
                  "assets/icons/chevron_right.svg",
                  colorFilter: ColorFilter.mode(
                    _textColor, // 원하는 색상
                    BlendMode.srcIn,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
