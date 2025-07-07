import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
          read
              ? SvgPicture.asset("assets/icons/ellipse.svg")
              : SizedBox(width: 5),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Headline2SemiBold16(text: notice),
              SizedBox(height: 12),
              Row(
                children: [
                  TeacherBadge(teacherName: teacher),
                  SizedBox(width: 8),
                  Caption1Regular11(text: date),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
