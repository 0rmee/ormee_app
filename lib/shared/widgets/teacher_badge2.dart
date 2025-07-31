import 'package:flutter/widgets.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

Widget TeacherBadge2(String teacherName) {
  return Row(
    children: [
      Label2Semibold12(text: teacherName),
      Label2Regular12(text: ' 선생님', color: OrmeeColor.gray[70]),
    ],
  );
}
