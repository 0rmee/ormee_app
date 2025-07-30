import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:intl/intl.dart';

class History extends StatelessWidget {
  final String keyword;
  final DateTime searchDate;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const History({
    super.key,
    required this.keyword,
    required this.searchDate,
    required this.onTap,
    required this.onDelete,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final searchDay = DateTime(date.year, date.month, date.day);

    if (searchDay == today) {
      return DateFormat('HH:mm').format(date);
    } else {
      return DateFormat('yy.MM.dd').format(date);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(child: Headline2Regular16(text: keyword)),
            Label1Regular14(
              text: _formatDate(searchDate),
              color: OrmeeColor.gray[50],
            ),
            const SizedBox(width: 10),
            GestureDetector(
              onTap: onDelete,
              child: SvgPicture.asset(
                'assets/icons/x.svg',
                color: OrmeeColor.gray[50],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
