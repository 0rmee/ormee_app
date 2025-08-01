import 'package:flutter/material.dart' hide Notification;
import 'package:ormee_app/feature/search/data/notification/model.dart';
import 'package:ormee_app/feature/notification/presentation/widgets/date_badge.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/notification_card.dart';
import 'package:intl/intl.dart';

class NotificationResult extends StatelessWidget {
  final List<Notification> notifications;
  final void Function(int id)? onTap;

  const NotificationResult({
    super.key,
    required this.notifications,
    this.onTap,
  });

  // 날짜별로 알림들을 그룹핑
  Map<String, List<Notification>> _groupNotificationsByDate() {
    final Map<String, List<Notification>> grouped = {};

    for (final notification in notifications) {
      final dateKey = DateFormat('yyyy-MM-dd').format(notification.createdAt);
      if (grouped[dateKey] == null) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(notification);
    }

    return grouped;
  }

  // 날짜 헤더 포맷팅 (한국어)
  String _formatKoreanDateHeader(DateTime dateTime) {
    return DateFormat('yyyy. MM. dd (E)', 'ko_KR').format(dateTime);
  }

  // 시간 포맷팅 (항상 오전/오후 시간으로)
  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour < 12 ? '오전' : '오후';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '$period ${displayHour}시 ${minute.toString().padLeft(2, '0')}분';
  }

  @override
  Widget build(BuildContext context) {
    if (notifications.isEmpty) {
      return const SizedBox.shrink();
    }

    final grouped = _groupNotificationsByDate();
    final dateKeys = grouped.keys.toList()
      ..sort((a, b) => b.compareTo(a)); // 최신순

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: dateKeys.length,
      itemBuilder: (context, index) {
        final dateKey = dateKeys[index];
        final dayNotifications = grouped[dateKey]!;
        final dateTime = DateTime.parse(dateKey);
        final dateHeader = _formatKoreanDateHeader(dateTime);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 날짜 뱃지
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: DateBadge(date: dateHeader),
            ),

            // 해당 날짜의 알림들
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: dayNotifications.length,
              itemBuilder: (context, notifIndex) {
                final notification = dayNotifications[notifIndex];

                return NotificationCard(
                  onReadStatusChanged: () => onTap?.call(notification.id),
                  read: notification.isRead,
                  id: notification.id,
                  parentId: notification.parentId,
                  type: notification.type,
                  profile: notification.authorImage, // null일 수 있음
                  headline: notification.header,
                  title: notification.title,
                  body: notification.body,
                  time: _formatTime(notification.createdAt),
                );
              },
              separatorBuilder: (context, notifIndex) =>
                  Divider(height: 1, color: OrmeeColor.gray[20]),
            ),

            // 마지막 날짜가 아니면 간격 추가
            if (index < dateKeys.length - 1) const SizedBox(height: 16),
          ],
        );
      },
    );
  }
}
