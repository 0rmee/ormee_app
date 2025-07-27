import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class QuestionButton extends StatelessWidget {
  final int lectureId;

  const QuestionButton({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    final activeColor = OrmeeColor.gray[20];
    final pressedColor = OrmeeColor.gray[40];
    final textColor = OrmeeColor.gray[90];

    return Container(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            context.push('/question/list/$lectureId');
          },
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: pressedColor,
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 7, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: activeColor,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [Headline2SemiBold16(text: '질문하기', color: textColor)],
            ),
          ),
        ),
      ),
    );
  }
}
