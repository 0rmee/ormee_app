import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

TextFormField ContentTextField() {
  return TextFormField(
    maxLines: null,
    minLines: 6,
    style: TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: OrmeeColor.gray[90],
    ),
    cursorColor: OrmeeColor.gray[60],
    decoration: InputDecoration(
      hintText: '내용을 입력하세요',
      hintStyle: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: OrmeeColor.gray[50],
      ),
      isDense: true,
      contentPadding: EdgeInsets.zero,
      border: InputBorder.none,
    ),
    onChanged: (value) {},
  );
}
