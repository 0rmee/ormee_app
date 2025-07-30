import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

Widget History() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Row(
      children: [
        Headline2Regular16(text: '검색어'),
        Spacer(),
        Label1Regular14(text: '25.06.13', color: OrmeeColor.gray[50]),
        SizedBox(width: 10),
        SvgPicture.asset('assets/icons/x.svg', color: OrmeeColor.gray[50]),
      ],
    ),
  );
}
