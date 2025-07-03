import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeBox extends StatelessWidget {
  final String text;
  final bool isCheck;

  const OrmeeBox({super.key, required this.text, required this.isCheck});

  @override
  Widget build(BuildContext context) {
    final activeColor = isCheck ? OrmeeColor.gray[70] : OrmeeColor.white;
    final pressedColor = isCheck ? OrmeeColor.gray[75] : OrmeeColor.gray[20];
    final textColor = isCheck ? OrmeeColor.white : OrmeeColor.gray[60];

    return IntrinsicWidth(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {},
          borderRadius: BorderRadius.circular(100),
          splashColor: Colors.transparent,
          highlightColor: pressedColor,
          child: Ink(
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: activeColor,
              border: Border.all(
                color: OrmeeColor.gray[30]!,
                width: isCheck ? 0 : 1,
              ),
            ),
            child: Center(
              child: Label1Semibold14(text: text, color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}
