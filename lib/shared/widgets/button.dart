import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

/* 예시
OrmeeButton(
              text: 'text',
              isTrue: false,
              assetName: 'assets/icons/trash.svg',
              dday: 'D-1',
            ),
            OrmeeButton(
              text: 'text',
              isTrue: true,
              trueAction: () {},
              assetName: 'assets/icons/trash.svg',
              dday: 'D-1',
            ),
*/

class OrmeeButton extends StatelessWidget {
  final String text;
  final bool isTrue;
  final VoidCallback? trueAction;
  final String? assetName;
  final String? dday;

  const OrmeeButton({
    super.key,
    required this.text,
    required this.isTrue,
    this.trueAction,
    this.assetName,
    this.dday,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isTrue ? OrmeeColor.purple[50] : OrmeeColor.gray[20];
    final pressedColor = isTrue ? OrmeeColor.purple[70] : OrmeeColor.gray[40];
    final textColor = isTrue ? OrmeeColor.white : OrmeeColor.gray[60];
    final ddayColor = OrmeeColor.white;

    return Container(
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
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // icon
                if (assetName != null) ...[
                  SvgPicture.asset(assetName!, color: textColor),
                  SizedBox(width: 8),
                ],
                Headline2SemiBold16(text: text, color: textColor),
                // DDAY
                if (dday != null) ...[
                  SizedBox(width: 8),
                  Container(
                    height: 20,
                    padding: EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: OrmeeColor.black.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Caption1Regular11(text: dday!, color: ddayColor),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
