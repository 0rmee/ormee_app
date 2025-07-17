import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_bloc.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_event.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_state.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class ContentTextField extends StatelessWidget {
  const ContentTextField({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<QuestionCreateBloc, QuestionCreateState>(
      builder: (context, state) {
        return TextFormField(
          onChanged: (value) =>
              context.read<QuestionCreateBloc>().add(ContentChanged(value)),
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
        );
      },
    );
  }
}
