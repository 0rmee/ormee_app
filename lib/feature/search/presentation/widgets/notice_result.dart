import 'package:flutter/material.dart';
import 'package:ormee_app/feature/search/data/notice/model.dart';
import 'package:ormee_app/shared/widgets/notice_card.dart';
import 'package:intl/intl.dart';

class NoticeResult extends StatelessWidget {
  final Notice notice;
  final VoidCallback onTap;

  const NoticeResult({super.key, required this.notice, required this.onTap});

  String _formatDate(DateTime date) {
    return DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(date);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        child: NoticeCard(
          notice: notice.title,
          teacher: notice.author,
          date: _formatDate(notice.postDate),
          read: false, // 읽음 상태는 별도 관리가 필요할 수 있음
        ),
      ),
    );
  }
}
