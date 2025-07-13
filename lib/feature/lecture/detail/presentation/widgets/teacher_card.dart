import 'package:flutter/material.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/question_button.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/day_badge.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class OrmeeTeacherCard extends StatelessWidget {
  final List<String> teacherNames; // 선생님 이름 리스트
  final List<String>? teacherImages; // 선생님 프로필 사진
  final String startTime; // 강의 시작 시간
  final String endTime; // 강의 종료 시간
  final String startPeriod; // 강의 시작 기간
  final String endPeriod; // 강의 종료 기간
  final List<String> day; // 요일 리스트

  const OrmeeTeacherCard({
    super.key,
    required this.teacherNames,
    this.teacherImages,
    required this.startTime,
    required this.endTime,
    required this.startPeriod,
    required this.endPeriod,
    required this.day,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      child: Row(
        children: [
          Wrap(
            children: [
              if (teacherImages != null && teacherImages!.isNotEmpty)
                teacherNames.length == 1
                    ? Profile(profileImageUrl: teacherImages![0], size1: 70)
                    : MultiProfile(
                        profileImageUrl: teacherImages![0],
                        otherProfileImageUrl: teacherImages!.length > 1
                            ? teacherImages![1]
                            : null,
                        size1: 70,
                        size2: 48,
                        border: 2,
                      )
              else
                teacherNames.length == 1
                    ? Profile(size1: 70)
                    : MultiProfile(size1: 70, size2: 48, border: 2),
            ],
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Wrap(
                    children: [
                      for (int i = 0; i < teacherNames.length; i++) ...[
                        Headline2SemiBold16(
                          text: teacherNames[i],
                          color: OrmeeColor.gray[80],
                        ),
                        if (i != teacherNames.length - 1)
                          Headline2SemiBold16(
                            text: ' ∙ ',
                            color: OrmeeColor.gray[80],
                          ),
                      ],
                    ],
                  ),
                  SizedBox(width: 2),
                  Label2Semibold12(text: '선생님', color: OrmeeColor.gray[60]),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Wrap(
                    children: [
                      for (int i = 0; i < day.length; i++) ...[
                        DayBadge(text: day[i]),
                        if (i != day.length - 1) SizedBox(width: 2),
                      ],
                    ],
                  ),
                  SizedBox(width: 4),
                  Label2Regular12(
                    text: '$startTime - $endTime',
                    color: OrmeeColor.gray[60],
                  ),
                ],
              ),
              SizedBox(height: 4),
              Label2Regular12(
                text: '$startPeriod - $endPeriod',
                color: OrmeeColor.gray[50],
              ),
            ],
          ),
          Spacer(),
          QuestionButton(),
        ],
      ),
    );
  }
}
