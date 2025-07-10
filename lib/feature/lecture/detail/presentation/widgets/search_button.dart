import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

Widget SearchButton() {
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    decoration: BoxDecoration(
      color: OrmeeColor.gray[20]!,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SvgPicture.asset(
          "assets/icons/search.svg",
          colorFilter: ColorFilter.mode(OrmeeColor.gray[50]!, BlendMode.srcIn),
        ),
        SizedBox(width: 10),
        Label1Regular14(text: '검색어를 입력하세요.', color: OrmeeColor.gray[50]),
      ],
    ),
  );
}
