import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class TeacherBadge extends StatelessWidget {
  final String teacherName;
  const TeacherBadge({super.key, required this.teacherName});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      decoration: BoxDecoration(
        color: OrmeeColor.gray[30]!,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            fit: FlexFit.loose,
            child: Caption2Semibold10(
              text: teacherName,
              color: OrmeeColor.gray[90],
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Caption2Regular10(text: " 선생님", color: OrmeeColor.gray[60]),
        ],
      ),
    );
  }
}
