import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class EssayAnswer extends StatelessWidget {
  final String answer;
  final String submission;
  final bool isCorrect;
  const EssayAnswer({
    super.key,
    required this.answer,
    required this.submission,
    required this.isCorrect,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: isCorrect
          ? Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: OrmeeColor.gray[20]!, width: 1),
              ),
              padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Label1Regular14(
                  text: answer,
                  color: OrmeeColor.systemPositive,
                ),
              ),
            )
          : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: OrmeeColor.gray[20]!, width: 1),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Label1Regular14(
                      text: submission,
                      color: OrmeeColor.systemError,
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: OrmeeColor.gray[10],
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Row(
                    children: [
                      Body2RegularNormal14(
                        text: "정답:",
                        color: OrmeeColor.gray[60],
                      ),
                      SizedBox(width: 8),
                      Label1Regular14(text: answer),
                      Spacer(),
                      SvgPicture.asset("assets/icons/cancel.svg"),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
