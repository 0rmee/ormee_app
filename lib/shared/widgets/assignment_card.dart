import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';
import 'package:ormee_app/shared/widgets/teacher_badge.dart';

class AssignmentCard extends StatelessWidget {
  final String assignment;
  final String state;
  final String teacher;
  final String period;
  final bool active;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.state,
    required this.period,
    required this.teacher,
    required this.active,
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
              Headline2SemiBold16(
                text: assignment,
                color: active ? OrmeeColor.black : OrmeeColor.gray[40],
              ),
              StateBadge(text: state),
            ],
          ),
          SizedBox(height: 18),
          Row(
            children: [
              TeacherBadge(teacherName: teacher),
              SizedBox(width: 10),
              Caption1Regular11(text: period),
            ],
          ),
        ],
      ),
    );
  }
}
