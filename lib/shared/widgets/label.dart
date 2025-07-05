import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

// Label(color: 'purple'),             // '질문' 텍스트 자동 표시
// Label(color: 'green'),              // '쪽지' 텍스트 자동 표시
// Label(color: 'blue', text: '과제'), // 커스텀 텍스트 사용

class Label extends StatelessWidget {
  final String color;
  final String? text;

  const Label({super.key, required this.color, this.text});

  String get _defaultText {
    switch (color.toLowerCase()) {
      case 'purple':
        return '질문';
      case 'green':
        return '쪽지';
      case 'blue':
        return '숙제';
      case 'orange':
        return '퀴즈';
      case 'gray':
        return '비활';
      default:
        return '';
    }
  }

  Color get _backgroundColor {
    switch (color.toLowerCase()) {
      case 'purple':
        return OrmeeColor.purple[5]!;
      case 'green':
        return OrmeeColor.accentYellowGreen[20]!;
      case 'blue':
        return OrmeeColor.accentBlue[20]!;
      case 'orange':
        return OrmeeColor.accentRedOrange[20]!;
      case 'gray':
        return OrmeeColor.gray[30]!;
      default:
        return OrmeeColor.gray[30]!;
    }
  }

  Color get _fontColor {
    switch (color.toLowerCase()) {
      case 'purple':
        return OrmeeColor.purple[50]!;
      case 'green':
        return OrmeeColor.accentYellowGreen[10]!;
      case 'blue':
        return OrmeeColor.accentBlue[10]!;
      case 'orange':
        return OrmeeColor.accentRedOrange[10]!;
      case 'gray':
        return OrmeeColor.gray[50]!;
      default:
        return OrmeeColor.gray[50]!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 34,
      height: 20,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _backgroundColor,
      ),
      child: Center(
        child: Caption2Semibold10(
          text: text ?? _defaultText,
          color: _fontColor,
        ),
      ),
    );
  }
}
