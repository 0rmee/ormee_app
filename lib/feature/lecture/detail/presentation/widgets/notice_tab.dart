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
        final pinnedNotices = state.pinnedNotices;

        if (notices.isEmpty && pinnedNotices.isEmpty) {
          return Center(
            child: Label1Regular14(
              text: '공지가 없어요.',
              color: OrmeeColor.gray[50],
            ),
          );
        }

        // 고정 공지와 일반 공지를 합쳐서 표시
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 20),
          itemCount: pinnedNotices.length + notices.length,
          itemBuilder: (context, index) {
            // 상단에 고정 공지 표시
            if (index < pinnedNotices.length) {
              final notice = pinnedNotices[index];
              return NoticeCard(
                noticeId: notice.id,

                notice: notice.title,
                teacher: notice.author,
                date: DateFormat(
                  'yyyy.MM.dd (E)',
                  'ko_KR',
                ).format(notice.postDate),
                onTap: () {
                  context.push('/notice/detail/${notice.id}');
                },
                isPinned: true,
              );
            }
            // 하단에 일반 공지 표시 (isPinned: false로 설정)
            else {
              final noticeIndex = index - pinnedNotices.length;
              final notice = notices[noticeIndex];
              return NoticeCard(
                noticeId: notice.id,
                notice: notice.title,
                teacher: notice.author,
                date: DateFormat(
                  'yyyy.MM.dd (E)',
                  'ko_KR',
                ).format(notice.postDate),
                onTap: () {
                  context.push('/notice/detail/${notice.id}');
                },
                isPinned: false,
              );
            }
          },
          separatorBuilder: (context, index) =>
              Divider(color: OrmeeColor.gray[20]),
        );
      } else if (state is NoticeError) {
        return Center(child: Text('에러: ${state.message}'));
      } else {
        return Center(
          child: Label1Regular14(text: '공지가 없어요.', color: OrmeeColor.gray[50]),
        );
      }
    },
  );
}
