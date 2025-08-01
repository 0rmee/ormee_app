import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeSingleChoiceAnswer extends StatelessWidget {
  final List<String?> items;
  final String submission;
  final String answer;
  final bool isCorrect;

  OrmeeSingleChoiceAnswer({
    Key? key,
    required this.items,
    required this.submission,
    required this.answer,
    required this.isCorrect,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int selectedIndex = items.indexOf(submission);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListView.separated(
          physics: const NeverScrollableScrollPhysics(), // 스크롤 비활성화 (필요한 경우 추가)
          shrinkWrap: true, // 부모 위젯의 크기에 맞게 축소
          itemCount: items.length,
          itemBuilder: (context, index) {
            final isSelected = selectedIndex == index;
            return Row(
              children: [
                SvgPicture.asset(
                  isSelected
                      ? 'assets/icons/checked_round.svg'
                      : 'assets/icons/n_checked_round.svg',
                  width: 24,
                  height: 24,
                  color: isSelected
                      ? (isCorrect ? Color(0xff00B853) : OrmeeColor.systemError)
                      : null,
                ),
                const SizedBox(width: 8),
                Label1Regular14(
                  text: items[index]!,
                  color: isSelected ? OrmeeColor.gray[90] : OrmeeColor.gray[60],
                ),
              ],
            );
          },
          separatorBuilder: (context, index) {
            return const SizedBox(height: 8); // 아이템 사이 간격
          },
        ),
        if (!isCorrect)
          Container(
            margin: EdgeInsets.only(top: 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(6),
              color: OrmeeColor.gray[10],
            ),
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Row(
              children: [
                Body2RegularNormal14(text: "정답:", color: OrmeeColor.gray[60]),
                SizedBox(width: 8),
                Label1Regular14(text: answer),
                Spacer(),
                SvgPicture.asset("assets/icons/cancel.svg"),
              ],
            ),
          ),
      ],
    );
  }
}
