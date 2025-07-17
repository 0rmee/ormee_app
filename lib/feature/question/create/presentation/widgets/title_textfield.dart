import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_bloc.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_event.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_state.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class TitleTextField extends StatelessWidget {
  const TitleTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCreateBloc, QuestionCreateState>(
      builder: (context, state) {
        return TextFormField(
          maxLength: 20,
          initialValue: state.title,
          onChanged: (value) {
            context.read<QuestionCreateBloc>().add(TitleChanged(value));
          },
          style: TextStyle(
            color: OrmeeColor.gray[80],
            fontFamily: 'Pretendard',
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
          cursorColor: OrmeeColor.gray[60],
          decoration: InputDecoration(
            hintText: '제목을 입력하세요',
            hintStyle: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: OrmeeColor.gray[50],
            ),
            counterText: '', // maxLength 카운터 숨김
            isDense: true,
            contentPadding: EdgeInsets.zero,
            border: InputBorder.none,
          ),
        );
      },
    );
  }
}
