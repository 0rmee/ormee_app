import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/notification/bloc/notification_bloc.dart';
import 'package:ormee_app/feature/notification/bloc/notification_event.dart';
import 'package:ormee_app/feature/notification/bloc/notification_state.dart';
import 'package:ormee_app/feature/notification/data/utils.dart';
import 'package:ormee_app/feature/notification/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/notification/presentation/widgets/date_badge.dart';
import 'package:ormee_app/feature/notification/presentation/widgets/tab.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 0;
  final types = ['과제', '질문', '공지'];

  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 마운트 된 후 이벤트 발생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(
        LoadNotifications(type: types[_currentIndex]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NoticeAppBar(title: "알림"),
        body: Column(
          children: [
            OrmeeTabBar2(
              tabs: types,
              currentIndex: _currentIndex,
              onTap: (index) {
                print(types[index]);
                setState(() {
                  _currentIndex = index;
                });
                context.read<NotificationBloc>().add(
                  LoadNotifications(type: types[index]),
                );
              },
            ),
            const SizedBox(height: 8),
            Expanded(
              child: BlocBuilder<NotificationBloc, NotificationState>(
                builder: (context, state) {
                  if (state is NotificationLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is NotificationLoaded) {
                    final grouped = state.groupedNotifications;
                    if (grouped.isEmpty) {
                      // 알림이 하나도 없을 때 보여줄 위젯
                      return Center(
                        child: Body1RegularReading16(
                          text: '${types[_currentIndex]} 알림이 없어요.',
                          color: OrmeeColor.gray[50],
                        ),
                      );
                    }
                    final dateKeys = grouped.keys.toList()
                      ..sort((a, b) => b.compareTo(a));

                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: dateKeys.length,
                      itemBuilder: (context, index) {
                        final dateKey = dateKeys[index];
                        final notifications = grouped[dateKey]!;
                        final dateTime = DateTime.parse(dateKey);
                        final dateHeader = formatKoreanDateHeader(dateTime);

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                                horizontal: 16,
                              ),
                              child: DateBadge(date: dateHeader),
                            ),
                            ListView.separated(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: notifications.length,
                              itemBuilder: (context, notifIndex) {
                                final n = notifications[notifIndex];
                                return NotificationCard(
                                  profile: n.authorImage,
                                  headline: n.header,
                                  title: n.title,
                                  body: n.content ?? n.body,
                                  time: n.formattedTime,
                                );
                              },
                              separatorBuilder: (context, notifIndex) =>
                                  Divider(
                                    height: 1,
                                    color: OrmeeColor.gray[20],
                                  ),
                            ),
                          ],
                        );
                      },
                    );
                  } else if (state is NotificationError) {
                    return Center(child: Text('에러: ${state.message}'));
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
