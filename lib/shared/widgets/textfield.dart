import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

// 사용법:
// 아래와 같이 컨트롤러와 상태 변수 선언 후 사용
//
// final TextEditingController _controller_1 = TextEditingController();
// bool isTextFieldNotEmpty1 = false; // 일반 bool 변수
//
// OrmeeTextField1(
//                 hintText: "이름을 입력하세요.",
//                 controller: _controller_id,
//                 focusNode: focusNode_id,
//                 textInputAction: TextInputAction.next,
//                 isTextNotEmpty: isTextFieldNotEmpty_id,
//                 onTextChanged: (text) {
//                   // BLoC 이벤트 발생 또는 setState 호출
//                   setState(() {
//                     isTextFieldNotEmpty_id = text.isNotEmpty;
//                   });
//                 },
//                 onFieldSubmitted: (term) {
//                   FocusScope.of(context).nextFocus();
//                 },
//               ),
//
// OrmeeTextField1(
//                 hintText: '비밀번호를 입력하세요.',
//                 controller: _controller_pw,
//                 focusNode: focusNode_pw,
//                 textInputAction: TextInputAction.done,
//                 isTextNotEmpty: isTextFieldNotEmpty_pw,
//                 isPassword: true,
//                 onTextChanged: (text) {
//                   setState(() {
//                     isTextFieldNotEmpty_pw = text.isNotEmpty;
//                   });
//                 },
//                 onFieldSubmitted: (term) {
//                   FocusScope.of(context).unfocus();
//                 },
//               ),

class OrmeeTextField extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final TextInputAction textInputAction;
  final Function(String) onFieldSubmitted;
  final bool? isPassword;
  final FocusNode focusNode;
  final Function(String)? onTextChanged;
  final String? errorText;

  const OrmeeTextField({
    Key? key,
    required this.hintText,
    required this.controller,
    required this.textInputAction,
    required this.onFieldSubmitted,
    required this.focusNode,
    this.isPassword,
    this.onTextChanged,
    this.errorText,
  }) : super(key: key);

  @override
  State<OrmeeTextField> createState() => _OrmeeTextField1State();
}

class _OrmeeTextField1State extends State<OrmeeTextField> {
  bool isObscure = true; // 비밀번호 숨김 상태 관리
  bool get isTextNotEmpty => widget.controller.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    widget.focusNode.addListener(() {
      setState(() {}); // 포커스 상태가 바뀔 때마다 다시 빌드
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      focusNode: widget.focusNode,
      textInputAction: widget.textInputAction,
      onFieldSubmitted: widget.onFieldSubmitted,
      onChanged: widget.onTextChanged, // 텍스트 변경 시 콜백 호출
      obscureText: widget.isPassword == true ? isObscure : false,
      obscuringCharacter: '*',
      style: TextStyle(
        fontFamily: 'Pretendard',
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: OrmeeColor.gray[100], // 또는 원하는 색상
      ),
      decoration: InputDecoration(
        isDense: true,
        // 에러 공간 완전히 제거
        errorStyle: TextStyle(height: 0, fontSize: 0),
        helperStyle: TextStyle(height: 0, fontSize: 0),
        // 에러 텍스트를 위한 공간 제거
        errorMaxLines: 1,
        // 헬퍼 텍스트 공간 제거
        helperText: '',
        // 컨텐츠 패딩 조정 (필요시)
        isCollapsed: false, // true로 하면 더 컴팩트해짐
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.gray[20]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.purple[50]!),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.systemError),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: OrmeeColor.systemError),
        ),
        errorText: widget.errorText,
        hintText: widget.hintText,
        hintStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: OrmeeColor.gray[50],
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 12),
            if (isTextNotEmpty && widget.focusNode.hasFocus)
              GestureDetector(
                onTap: () {
                  widget.controller.clear();
                  if (widget.onTextChanged != null) {
                    widget.onTextChanged!(''); // 텍스트 변경 콜백 호출
                  }
                },
                child: SvgPicture.asset(
                  "assets/icons/xCircle.svg",
                  colorFilter: ColorFilter.mode(
                    OrmeeColor.gray[50]!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            SizedBox(width: 12),
            if (widget.isPassword == true && isTextNotEmpty)
              GestureDetector(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure; // 토글
                  });
                },
                child: SvgPicture.asset(
                  isObscure
                      ? "assets/icons/eye_off.svg"
                      : "assets/icons/eye_on.svg",
                  colorFilter: ColorFilter.mode(
                    OrmeeColor.gray[50]!,
                    BlendMode.srcIn,
                  ),
                ),
              ),
            SizedBox(width: 16),
          ],
        ),
      ),
    );
  }
}
