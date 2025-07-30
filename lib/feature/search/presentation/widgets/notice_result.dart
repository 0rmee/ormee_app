import 'package:flutter/material.dart';
import 'package:ormee_app/shared/widgets/notice_card.dart';

Widget NoticeResult() {
  return GestureDetector(
    onTap: () {
      // context.push('/notice/detail/${notice.id}');
    },
    child: NoticeCard(
      notice: "출석 체크 꼭 하세요",
      teacher: "강수이",
      date: "2024.06.06 (수)",
      read: false,
    ),
  );
}
