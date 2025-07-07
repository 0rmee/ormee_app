import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

/* 사용예시
OrmeeLectureCard(
                      title: '오름토익 기본반 RC',
                      teacherNames: '강수이 • 최윤선 T',
                      subText: '재수하지 말자',
                      dDay: 'D-16',
                    ),
*/

class OrmeeLectureCard extends StatelessWidget {
  final String title;
  final String teacherNames;
  final String subText;
  final String? dDay;

  const OrmeeLectureCard({
    super.key,
    required this.title,
    required this.teacherNames,
    required this.subText,
    this.dDay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        border: Border.all(color: OrmeeColor.gray[20]!, width: 1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline2SemiBold16(text: title),
              const SizedBox(height: 16),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      color: OrmeeColor.accentRedOrange[5],
                    ),
                    child: Caption2Semibold10(
                      text: teacherNames,
                      color: OrmeeColor.accentRedOrange[20],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    subText,
                    style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      height: 1.4,
                      letterSpacing: -0.2,
                      color: OrmeeColor.gray[70],
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (dDay != null)
            Label1Medium14(text: dDay!, color: OrmeeColor.gray[60]),
        ],
      ),
    );
  }
}
