import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

// 미제출, 제출완료 외 pruple[400]
//StateBadge(text: '미제출')
//StateBadge(text: '제출완료')
//StateBadge(text: 'D-16')

class StateBadge extends StatelessWidget {
  final String text;
  const StateBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    switch (text) {
      case '진행중':
        backgroundColor = OrmeeColor.purple[50]!;
        break;
      case '미제출':
        backgroundColor = OrmeeColor.gray[40]!;
        break;
      case '제출완료':
        backgroundColor = OrmeeColor.purple[30]!;
        break;
      default:
        backgroundColor = OrmeeColor.purple[50]!;
    }
    return Container(
      width: 50,
      height: 20,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: Caption2Semibold10(text: text, color: OrmeeColor.white),
      ),
    );
  }
}
