import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class TimeOverDialog extends StatelessWidget {
  final String titleText;
  final String? contentText;
  final String? icon;
  final VoidCallback onConfirm;

  TimeOverDialog({
    this.titleText = "퀴즈가 종료되었어요!",
    this.contentText = "더 이상 응시할 수 없어요.",
    required this.onConfirm,
    this.icon = "assets/icons/timer.svg",
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: OrmeeColor.white,
      surfaceTintColor: Colors.transparent,
      icon: icon != null
          ? SvgPicture.asset(icon!, color: OrmeeColor.purple[50])
          : null,
      title: Center(
        child: Heading2SemiBold20(text: titleText, color: OrmeeColor.gray[90]),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (contentText != null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Label1Regular14(
                    text: contentText!,
                    color: OrmeeColor.gray[90],
                  ),
                ],
              ),
              SizedBox(height: 30),
            ],
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: OrmeeButton(
                    trueAction: onConfirm,
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
