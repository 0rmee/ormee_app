import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_state.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/notice_card.dart';
import 'package:intl/intl.dart';

Widget NoticeTab() {
  return BlocBuilder<NoticeBloc, NoticeState>(
    builder: (context, state) {
      if (state is NoticeLoading) {
        return Center(child: CircularProgressIndicator());
      } else if (state is NoticeLoaded) {
        final notices = state.notices;

        if (notices.isEmpty) {
          return Center(
            child: Label1Regular14(
              text: '공지가 없어요.',
              color: OrmeeColor.gray[50],
            ),
          );
        }
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: notices.length,
          itemBuilder: (context, index) {
            final notice = notices[index];
            return GestureDetector(
              onTap: () {
                context.push('/notice/detail/${notice.id}');
              },
              child: NoticeCard(
                notice: notice.title,
                teacher: notice.author,
                date: DateFormat(
                  'yyyy.MM.dd (E)',
                  'ko_KR',
                ).format(notice.postDate),
                read: false,
              ),
            );
          },
          separatorBuilder: (context, index) =>
              Divider(color: OrmeeColor.gray[20]),
        );
      } else if (state is NoticeError) {
        return Center(child: Text('에러: ${state.message}'));
      } else {
        return Label1Regular14(text: '공지가 없어요.', color: OrmeeColor.gray[50]);
      }
    },
  );
}
