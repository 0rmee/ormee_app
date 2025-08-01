import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class MyPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyPageAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      surfaceTintColor: OrmeeColor.white,
      backgroundColor: OrmeeColor.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      flexibleSpace: SafeArea(
        child: Align(
          alignment: Alignment.centerLeft,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20.0,
              vertical: 14.0,
            ),
            child: Heading1SemiBold22(text: title, color: OrmeeColor.gray[90]),
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(72.0);
}
