import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class OrmeeDialog extends StatelessWidget {
  final String titleText;
  final String contentText;
  final String icon;
  final VoidCallback onConfirm;

  OrmeeDialog({
    required this.titleText,
    required this.contentText,
    required this.onConfirm,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: OrmeeColor.white,
      surfaceTintColor: Colors.transparent,
      icon: SvgPicture.asset(icon, color: OrmeeColor.purple[50]),
      title: Heading2SemiBold20(text: titleText, color: OrmeeColor.gray[90]),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.9,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Label1Regular14(text: contentText, color: OrmeeColor.gray[90]),
              ],
            ),
            SizedBox(height: 30),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(child: OrmeeButton(text: '취소', isTrue: false)),
                SizedBox(width: 12),
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
