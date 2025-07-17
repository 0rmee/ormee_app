import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class LectureEnterDialog extends StatelessWidget {
  final int lectureId;
  final String lectureTitle;
  final List<String> teacherNames; // 선생님 이름 리스트
  final List<String>? teacherImages; // 선생님 프로필 사진

  const LectureEnterDialog({
    super.key,
    required this.lectureId,
    required this.lectureTitle,
    required this.teacherNames,
    this.teacherImages,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: OrmeeColor.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
            SizedBox(height: 16),
            Headline2SemiBold16(text: lectureTitle),
            SizedBox(height: 6),
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
              ],
            ),
            SizedBox(height: 20),
            Heading2SemiBold20(
              text: '강의실에 입장하시겠어요?',
              color: OrmeeColor.gray[90],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: OrmeeButton(text: '취소', isTrue: false)),
                SizedBox(width: 12),
                Expanded(
                  child: OrmeeButton(
                    trueAction: () {
                      context.read<LectureHomeBloc>().add(
                        EnterLecture(lectureId),
                      );
                      context.pop();
                    },
                    text: '확인',
                    isTrue: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
