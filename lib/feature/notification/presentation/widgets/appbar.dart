import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class NoticeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final int count;

  const NoticeAppBar({Key? key, required this.title, required this.count})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: OrmeeColor.white,
      backgroundColor: OrmeeColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            child: Row(
              children: [
                Heading1SemiBold22(text: title, color: OrmeeColor.gray[90]),
                SizedBox(width: 4),
                Heading1Regular22(text: '$count', color: OrmeeColor.purple[50]),
                Spacer(),
                GestureDetector(
                  onTap: () => context.push('/notification/search'),
                  child: SvgPicture.asset(
                    "assets/icons/search_20.svg",
                    color: OrmeeColor.gray[60],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72.0);
}
