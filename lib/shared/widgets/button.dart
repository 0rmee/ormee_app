import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeButton extends StatelessWidget {
  final String text;
  final bool isTrue;
  final VoidCallback? trueAction;

  const OrmeeButton({
    super.key,
    required this.text,
    required this.isTrue,
    this.trueAction,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isTrue ? OrmeeColor.purple[50] : OrmeeColor.gray[20];
    final pressedColor = isTrue ? OrmeeColor.purple[70] : OrmeeColor.gray[40];
    final textColor = isTrue ? OrmeeColor.white : OrmeeColor.gray[60];

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: OrmeeColor.white,
        border: Border(top: BorderSide(color: OrmeeColor.gray[10]!, width: 1)),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isTrue ? trueAction : () => context.pop(),
          borderRadius: BorderRadius.circular(12),
          splashColor: Colors.transparent,
          highlightColor: pressedColor,
          child: Ink(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
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
