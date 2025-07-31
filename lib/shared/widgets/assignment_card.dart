import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';
import 'package:ormee_app/shared/widgets/teacher_badge.dart';
import 'package:ormee_app/shared/widgets/teacher_badge2.dart';

class AssignmentCard extends StatelessWidget {
  final String assignment;
  final String state;
  final String teacher;
  final String period;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.state,
    required this.period,
    required this.teacher,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 12, 0, 22),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Headline2SemiBold16(text: assignment, color: OrmeeColor.black),
              StateBadge(text: state),
            ],
          ),
          SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TeacherBadge2(teacher),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 6),
                height: 12,
                width: 1,
                color: OrmeeColor.gray[20],
              ),
              Label2Regular12(text: period, color: OrmeeColor.gray[50]),
            ],
          ),
        ],
      ),
    );
  }
}
