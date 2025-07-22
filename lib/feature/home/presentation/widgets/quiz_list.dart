import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';

class QuizCard {
  final String lectureTitle;
  final String quizTitle;
  final String quizDueTime;

  QuizCard({
    required this.lectureTitle,
    required this.quizTitle,
    required this.quizDueTime,
  });
}

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
                  text:
                      'D${DateFormat('yyyy.MM.dd HH:mm').parse(quiz.quizDueTime).difference(DateTime.now()).inDays}',
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
