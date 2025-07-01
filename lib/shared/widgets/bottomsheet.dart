import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeBottomSheet extends StatelessWidget {
  final String text;
  final bool isCheck;

  const OrmeeBottomSheet({
    super.key,
    required this.text,
    required this.isCheck,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isCheck ? OrmeeColor.purple[50] : OrmeeColor.gray[20];
    final pressedColor = isCheck ? OrmeeColor.purple[70] : OrmeeColor.gray[40];
    final textColor = isCheck ? OrmeeColor.white : OrmeeColor.gray[60];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 39),
      color: OrmeeColor.white,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isCheck ? () {} : null,
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: pressedColor,
          child: Ink(
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: activeColor,
            ),
            child: Center(
              child: Title4SemiBold16(text: text, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
