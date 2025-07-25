import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

Widget StudentBubble(BuildContext context, String text) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          decoration: BoxDecoration(
            color: OrmeeColor.purple[50],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Body2RegularNormal14(text: text, color: OrmeeColor.white),
        ),
      ),
      Transform.rotate(
        angle: math.pi,
        child: SvgPicture.asset(
          'assets/icons/polygon.svg',
          color: OrmeeColor.purple[50],
        ),
      ),
    ],
  );
}
