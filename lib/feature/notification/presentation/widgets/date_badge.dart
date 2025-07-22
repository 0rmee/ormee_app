import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class DateBadge extends StatelessWidget {
  final String date;
  const DateBadge({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xfff0f1f2),
          borderRadius: BorderRadius.circular(100),
        ),
        child: Center(
          child: Label2Regular12(text: date, color: OrmeeColor.gray[70]),
        ),
      ),
    );
  }
}
