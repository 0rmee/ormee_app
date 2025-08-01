import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

// 사용법:
// 아래와 같이 컨트롤러 변수 선언 후 사용
//
// final TextEditingController _controller_1 = TextEditingController();

class OrmeeTextField2 extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final Function(String) onSelectionUnfocused;

  OrmeeTextField2({
    required this.hintText,
    required this.controller,
    required this.textInputAction,
    required this.onSelectionUnfocused,
  });

  @override
  Widget build(BuildContext context) {
    final FocusNode focusNode = FocusNode();

    focusNode.addListener(() {
      if (!focusNode.hasFocus) {
        onSelectionUnfocused(controller.text);
      }
    });

    return TextFormField(
      controller: controller,
      textInputAction: textInputAction,
      focusNode: focusNode,
      style: TextStyle(fontSize: 14, color: OrmeeColor.black),
      decoration: InputDecoration(
        filled: true,
        fillColor: OrmeeColor.white,
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.gray[20]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.purple[50]!),
        ),
        hintText: hintText,
        hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: OrmeeColor.gray[50],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
