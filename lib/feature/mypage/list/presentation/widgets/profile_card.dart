import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class ProfileCard extends StatelessWidget {
  final String name;

  const ProfileCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 회원정보 수정 화면 바로가기
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: OrmeeColor.gray[10],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Profile(size1: 24),
                SizedBox(width: 12),
                Headline1SemiBold18(text: name, color: OrmeeColor.gray[800]),
              ],
            ),
            SvgPicture.asset(
              'assets/icons/arrow_right.svg',
              width: 20,
              color: OrmeeColor.gray[30],
            ),
          ],
        ),
      ),
    );
  }
}
