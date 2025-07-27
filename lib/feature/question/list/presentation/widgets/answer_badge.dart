import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class AnswerBadge extends StatelessWidget {
  final bool answered;

  const AnswerBadge({super.key, required this.answered});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: answered ? OrmeeColor.purple[5] : OrmeeColor.gray[30],
      ),
      width: 50,
      height: 20,
      child: Caption2Semibold10(
        text: answered ? '답변완료' : '미답변',
        color: answered ? OrmeeColor.purple[50] : OrmeeColor.gray[50],
      ),
    );
  }
}
