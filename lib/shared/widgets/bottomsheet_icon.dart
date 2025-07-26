import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

import '../theme/app_fonts.dart';

class OrmeeIconBottomSheet extends StatelessWidget {
  final String text;
  final String icon;
  final bool isLike;
  final VoidCallback? ontTap;

  const OrmeeIconBottomSheet({
    super.key,
    required this.text,
    required this.icon,
    required this.isLike,
    this.ontTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 48),
      decoration: BoxDecoration(
        color: OrmeeColor.white,
        border: Border(top: BorderSide(color: OrmeeColor.gray[10]!, width: 1)),
      ),
      child: GestureDetector(
        onTap: ontTap,
        child: Row(
          children: [
            SvgPicture.asset(icon),
            const SizedBox(width: 4),
            Headline2SemiBold16(
              text: text,
              color: isLike ? OrmeeColor.gray[60] : OrmeeColor.purple[50],
            ),
          ],
        ),
      ),
    );
  }
}