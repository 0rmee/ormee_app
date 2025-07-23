import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class HtmlTextWidget extends StatelessWidget {
  final String text;

  const HtmlTextWidget({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Html(
      data: text,
      style: {
        "*": Style(
          fontFamily: 'Pretendard',
          fontSize: FontSize(16),
          fontWeight: FontWeight.w400,
          lineHeight: LineHeight(1.55),
          letterSpacing: -0.02 * 16,
          color: OrmeeColor.gray[90],
        ),
        "b": Style(fontWeight: FontWeight.w700),
        "i": Style(fontStyle: FontStyle.italic),
        "u": Style(textDecoration: TextDecoration.underline),
      },
    );
  }
}
