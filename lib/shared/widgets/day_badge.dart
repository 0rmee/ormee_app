import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

//DayBadge(text: '월')


class DayBadge extends StatelessWidget {
  final String text;
  const DayBadge({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width:20,
      height:20,
      decoration: BoxDecoration(
        color: OrmeeColor.purple[15]!,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Center(child: Label2Regular12(text: text, color: OrmeeColor.purple[40]!)),
    );
  }
}
