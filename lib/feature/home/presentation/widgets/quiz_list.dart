import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/home/data/models/quiz_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';

class QuizCardSlider extends StatefulWidget {
  final List<QuizCard> quizzes;

  const QuizCardSlider({super.key, required this.quizzes});

  @override
  State<QuizCardSlider> createState() => _QuizCardSliderState();
}

class _QuizCardSliderState extends State<QuizCardSlider> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.12,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: widget.quizzes.length,
        padding: EdgeInsets.only(left: 20), // 왼쪽 패딩
        itemBuilder: (context, index) {
          final quiz = widget.quizzes[index];
          final isLast = index == widget.quizzes.length - 1;

          return Container(
            width: MediaQuery.of(context).size.width * 0.44, // 화면 너비의 절반
            margin: EdgeInsets.only(
              right: isLast ? 20 : 8,
            ), // 마지막은 오른쪽 패딩, 나머지는 간격
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Label2Semibold12(
                  text: quiz.lectureTitle,
                  color: OrmeeColor.gray[50],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 2),
                Label1Semibold14(
                  text: quiz.quizTitle,
                  color: OrmeeColor.gray[90],
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                Spacer(),
                StateBadge(
                  text: () {
                    try {
                      // 날짜 파싱
                      final dueDate = DateFormat('yyyy.MM.dd HH:mm')
                          .parseStrict(
                            quiz.quizDueTime.trim(), // 공백 제거
                          );

                      final now = DateTime.now();
                      final difference = dueDate.difference(now).inDays;

                      // 음수일 경우 D+ 처리
                      final ddayText = difference < 0
                          ? 'D+${-difference}'
                          : 'D-${difference}';
                      return ddayText;
                    } catch (e) {
                      print('날짜 파싱 에러: ${quiz.quizDueTime}, $e');
                      return 'D-?';
                    }
                  }(),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
