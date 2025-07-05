import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

// 사용 예시
// Fab(action: someFunction)

// 또는 직접 함수 전달
// Fab(action: () => Get.to(() => CreateIedu()))

class Fab extends StatelessWidget {
  final Function()? action;

  const Fab({super.key, this.action});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      shape: CircleBorder(),
      onPressed: action,
      elevation: 5,
      backgroundColor: OrmeeColor.purple[40],
      splashColor: OrmeeColor.purple[50],
      child: SvgPicture.asset(
        'assets/icons/plus.svg',
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(Colors.white, BlendMode.srcIn),
      ),
    );
  }
}
