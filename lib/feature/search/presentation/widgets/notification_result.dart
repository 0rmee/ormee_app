import 'package:flutter/material.dart';
import 'package:ormee_app/feature/notification/presentation/widgets/date_badge.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/notification_card.dart';

Widget NotificationResult() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: DateBadge(date: "2024. 07. 11 (토)"),
      ),
      ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: 3,
        itemBuilder: (context, notifIndex) {
          return NotificationCard(
            onReadStatusChanged: () {},
            read: false,
            id: 1,
            parentId: 1,
            type: "공지",
            // profile: n.authorImage,
            headline: "오름토익 기본반",
            title: "선생님 이거 어떻게 풀어요?",
            body: "답변이 등록되었습니다. 확인해보세요!",
            time: "오전 8시 40분",
          );
        },
        separatorBuilder: (context, notifIndex) =>
            Divider(height: 1, color: OrmeeColor.gray[20]),
      ),
    ],
  );
}
