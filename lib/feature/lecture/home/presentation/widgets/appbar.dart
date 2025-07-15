import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class LectureHomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int count;

  const LectureHomeAppBar({Key? key, required this.count}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: OrmeeColor.white,
      backgroundColor: OrmeeColor.white,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Heading1SemiBold22(text: '강의실', color: OrmeeColor.gray[90]),
          SizedBox(width: 4),
          Heading1Regular22(text: '$count', color: OrmeeColor.purple[50]),
        ],
      ),
      centerTitle: false,
      actions: [
        Container(
          // margin: const EdgeInsets.only(right: 20),
          child: IconButton(
            onPressed: () {},
            icon: SvgPicture.asset('assets/icons/scan.svg'),
            color: OrmeeColor.gray[90],
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(52.0);
}
