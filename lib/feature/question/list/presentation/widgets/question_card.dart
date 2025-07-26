import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/question/list/data/model.dart';
import 'package:ormee_app/feature/question/list/presentation/widgets/answer_badge.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class QuestionCard extends StatelessWidget {
  final QuestionListModel question;

  const QuestionCard({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 18),
      child: Column(
        children: [
          Row(
            children: [
              question.isLocked
                  ? SvgPicture.asset('assets/icons/lock.svg', width: 20)
                  : SizedBox(),
              question.isLocked ? SizedBox(width: 6) : SizedBox(),
              Body1SemiBold16(
                text: question.title,
                color: OrmeeColor.gray[90],
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Label2Regular12(
                    text: maskSecondCharacter(question.author),
                    color: OrmeeColor.gray[60],
                  ),
                  VerticalDivider(
                    width: 12,
                    thickness: 1,
                    color: OrmeeColor.gray[20],
                  ),
                  Label2Regular12(
                    text: DateFormat('yy.MM.dd').format(question.createdAt),
                    color: OrmeeColor.gray[60],
                  ),
                ],
              ),
              AnswerBadge(answered: question.isAnswered)
            ],
          ),
        ],
      ),
    );
  }

  String maskSecondCharacter(String name) {
    if (name.length < 2) return name;
    return '${name[0]}*${name.substring(2)}';
  }
}
