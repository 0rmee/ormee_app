import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class MyPageCard extends StatelessWidget {
  final String icon;
  final String title;
  final VoidCallback onTap;

  const MyPageCard({super.key, required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Row(
          children: [
            SvgPicture.asset(icon, width: 16, color: OrmeeColor.gray[50]),
            SizedBox(width: 12),
            Headline2Regular16(text: title, color: OrmeeColor.gray[90])
          ],
        ),
      )
    );
  }
}