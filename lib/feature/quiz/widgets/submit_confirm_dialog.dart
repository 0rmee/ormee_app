import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class SubmitConfirmDialog extends StatelessWidget {
  final String titleText;
  final String? contentText;
  final String? icon;
  final VoidCallback onConfirm;

  SubmitConfirmDialog({
    this.titleText = "퀴즈를 제출할까요?",
    this.contentText = "제출한 퀴즈는 수정하거나 삭제할 수 없어요.",
    required this.onConfirm,
    this.icon = "assets/icons/check_24.svg",
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
                    text: '돌아가기',
                    isTrue: false,
                    falseAction: () {
                      Navigator.of(context, rootNavigator: true).pop(false);
                    },
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: OrmeeButton(
                    trueAction: onConfirm,
                    text: '제출하기',
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
