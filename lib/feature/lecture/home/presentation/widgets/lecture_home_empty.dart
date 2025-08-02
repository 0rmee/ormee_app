import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/button.dart';

class LectureHomeEmpty extends StatelessWidget {
  final bool? qr;
  final String? text;
  final Bloc? bloc;
  LectureHomeEmpty({super.key, this.qr, this.text, this.bloc});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset('assets/icons/ormee_empty.svg'),
          SizedBox(height: 10),
          Body2RegularNormal14(
            text: text ?? '수강 중인 강의가 없어요',
            color: OrmeeColor.gray[50],
          ),
          SizedBox(height: 24),
          if (qr != null)
            OrmeeButton(
              text: 'QR코드로 강의실 입장하기',
              isTrue: true,
              trueAction: () {
                context.push('/qr-scanner', extra: bloc);
              },
            ),
        ],
      ),
    );
  }
}
