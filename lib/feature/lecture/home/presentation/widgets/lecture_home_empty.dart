import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

Widget LectureHomeEmpty() {
  return Center(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SvgPicture.asset('assets/icons/ormee_empty.svg'),
        SizedBox(height: 10),
        Body2RegularNormal14(text: '수강 중인 강의가 없어요', color: OrmeeColor.gray[50]),
        SizedBox(height: 24),
        OrmeeButton(text: 'QR코드로 강의실 입장하기', isTrue: true, trueAction: () {}),
      ],
    ),
  );
}
