import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class LectureCard extends StatelessWidget {
  final String title; // 강의명
  final List<String> teacherNames; // 선생님 이름 리스트
  final List<String>? teacherImages; // 선생님 프로필 사진
  final String? description; // 설명
  final String startPeriod; // 강의 시작 기간
  final String endPeriod; // 강의 종료 기간

  const LectureCard({
    super.key,
    required this.title,
    required this.teacherNames,
    this.teacherImages,
    this.description,
    required this.startPeriod,
    required this.endPeriod,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: OrmeeColor.gray[10],
        borderRadius: BorderRadius.circular(20),
      ),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
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
              SizedBox(height: 14),
              Headline2SemiBold16(text: title),
              SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: OrmeeColor.gray[30],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          children: [
                            for (int i = 0; i < teacherNames.length; i++) ...[
                              Caption2Semibold10(
                                text: teacherNames[i],
                                color: OrmeeColor.gray[90],
                              ),
                              if (i != teacherNames.length - 1)
                                Caption2Semibold10(
                                  text: ' ∙ ',
                                  color: OrmeeColor.gray[90],
                                ),
                            ],
                          ],
                        ),
                        SizedBox(width: 2),
                        Caption2Semibold10(
                          text: '선생님',
                          color: OrmeeColor.gray[60],
                        ),
                      ],
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(width: 4),
                    Label2Regular12(text: description!),
                  ],
                ],
              ),
              SizedBox(height: 5),
              Label2Regular12(
                text: '$startPeriod - $endPeriod',
                color: OrmeeColor.gray[40],
              ),
            ],
          ),
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                // TODO: 팝업
              },
              child: SvgPicture.asset(
                'assets/icons/more_vert.svg',
                // width: 24,
                // height: 24,
                color: OrmeeColor.gray[60],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
