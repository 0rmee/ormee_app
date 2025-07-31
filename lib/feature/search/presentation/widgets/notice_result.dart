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
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: NoticeCard(
        noticeId: notice.id,
        notice: notice.title,
        teacher: notice.author,
        date: DateFormat('yyyy.MM.dd (E)', 'ko_KR').format(notice.postDate),
        onTap: onTap,
        isPinned: false,
      ),
    );
  }
}
