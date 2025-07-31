import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/teacher_badge.dart';

class NoticeCard extends StatelessWidget {
  final bool read;
  final String notice;
  final String teacher;
  final String date;
  const NoticeCard({
    super.key,
    required this.date,
    required this.notice,
    required this.teacher,
    this.read = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 18),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Headline2SemiBold16(text: notice),
                  read
                      ? SizedBox(width: 5)
                      : Container(
                          padding: EdgeInsets.only(left: 6),
                          child: SvgPicture.asset("assets/icons/ellipse.svg"),
                        ),
                ],
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  TeacherBadge(teacherName: teacher),
                  SizedBox(width: 8),
                  Label2Regular12(text: date, color: OrmeeColor.gray[40]),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
