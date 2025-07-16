import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class InfoText extends StatelessWidget {
  final String text;
  const InfoText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(2, 0, 2, 4),
      child: Label1Semibold14(text: text),
    );
  }
}
