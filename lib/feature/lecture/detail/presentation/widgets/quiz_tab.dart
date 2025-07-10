import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/assignment_card.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_state.dart';
import 'package:intl/intl.dart';

String _formatDate(DateTime date) {
  return DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(date);
}

Widget QuizTab() {
  return BlocBuilder<QuizBloc, QuizState>(
    builder: (context, state) {
      if (state is QuizLoading) {
        return Center(child: CircularProgressIndicator());
      }

      if (state is QuizError) {
        return Center(
          child: Label1Regular14(
            text: '퀴즈를 불러오지 못했습니다.',
            color: OrmeeColor.gray[50],
          ),
        );
      }

      if (state is QuizLoaded) {
        final quizzes = state.quizzes;

        if (quizzes.isEmpty) {
          return Center(
            child: Label1Regular14(
              text: '퀴즈가 없어요.',
              color: OrmeeColor.gray[50],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: quizzes.length,
          itemBuilder: (context, index) {
            final quiz = quizzes[index];

            return AssignmentCard(
              assignment: quiz.title,
              state: 'D-16', // TODO: 남은 날짜 계산 필요
              period:
                  '${_formatDate(quiz.openTime)} - ${_formatDate(quiz.dueTime)}',
              teacher: quiz.author,
              active: !quiz.submitted,
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: OrmeeColor.gray[20]),
        );
      }

      return SizedBox.shrink(); // 초기 상태 등
    },
  );
}
