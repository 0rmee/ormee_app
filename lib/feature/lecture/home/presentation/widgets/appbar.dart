import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/qr_scanner.dart';
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
          child: IconButton(
            onPressed: () {
              final bloc = context.read<LectureHomeBloc>();
              context.push('/qr-scanner', extra: bloc);
            },
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
