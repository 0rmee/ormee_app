import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/assignment_card.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_state.dart';
import 'package:intl/intl.dart';

Widget HomeworkTab() {
  return BlocBuilder<HomeworkBloc, HomeworkState>(
    builder: (context, state) {
      if (state is HomeworkLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      if (state is HomeworkError) {
        return Center(
          child: Label1Regular14(
            text: '숙제를 불러오지 못했습니다.',
            color: OrmeeColor.gray[50],
          ),
        );
      }

      if (state is HomeworkLoaded) {
        final homeworks = state.homeworks;

        if (homeworks.isEmpty) {
          return Center(
            child: Label1Regular14(
              text: '숙제가 없어요.',
              color: OrmeeColor.gray[50],
            ),
          );
        }

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: homeworks.length,
          itemBuilder: (context, index) {
            final hw = homeworks[index];
            final remainingDays = hw.dueTime.difference(DateTime.now()).inDays;

            return InkWell(
              onTap: () => context.push(
                '/lecture/detail/homework/${hw.id}/create',
                extra: hw.title,
              ),
              child: GestureDetector(
                onTap: () {
                  context.push('/homework/detail/${hw.id}');
                },
                child: AssignmentCard(
                  assignment: hw.title,
                  state: 'D-${remainingDays > 0 ? remainingDays : 0}',
                  period:
                      '${_formatDate(hw.openTime)} - ${_formatDate(hw.dueTime)}',
                  teacher: hw.author,
                  active: !hw.submitted,
                ),
              ),
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: OrmeeColor.gray[20]),
        );
      }

      return const SizedBox.shrink();
    },
  );
}

String _formatDate(DateTime date) {
  return DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(date);
}
