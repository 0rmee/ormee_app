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
import 'package:ormee_app/shared/widgets/notification_card.dart';

class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  int _currentIndex = 0;
  final types = ['과제', '질문', '공지'];

  // 각 타입별 카운트를 저장할 맵
  Map<String, int> _typeCounts = {};

  @override
  void initState() {
    super.initState();
    // 위젯이 완전히 마운트 된 후 이벤트 발생
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NotificationBloc>().add(
        LoadNotifications(type: types[_currentIndex]),
      );
      // 각 타입별 카운트 미리 로드
      _loadAllTypeCounts();
    });
  }

  // 현재 선택된 타입의 카운트만 업데이트
  void _updateCurrentTypeCount() async {
    final repository = context.read<NotificationBloc>().repository;
    final currentType = types[_currentIndex];

    try {
      final response = await repository.fetchNotifications(type: currentType);
      if (mounted) {
        setState(() {
          _typeCounts[currentType] = response.count;
        });
      }
    } catch (e) {
      print('Failed to update count for $currentType: $e');
    }
  }

  // 모든 타입의 카운트를 미리 로드
  void _loadAllTypeCounts() async {
    final repository = context.read<NotificationBloc>().repository;

    for (String type in types) {
      try {
        final response = await repository.fetchNotifications(type: type);
        if (mounted) {
          setState(() {
            _typeCounts[type] = response.count;
          });
        }
      } catch (e) {
        print('Failed to load count for $type: $e');
        if (mounted) {
          setState(() {
            _typeCounts[type] = 0;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: BlocBuilder<NotificationBloc, NotificationState>(
          builder: (context, state) {
            // 전체 카운트 가져오기
            int totalCount = 0;
            if (state is NotificationLoaded) {
              totalCount = state.totalCount;
            }

            return Column(
              children: [
                NoticeAppBar(title: "알림", count: totalCount),
                OrmeeTabBar2(
                  tabs: types,
                  currentIndex: _currentIndex,
                  notifications: types
                      .map((type) => _typeCounts[type] ?? 0)
                      .toList(),
                  onTap: (index) {
                    setState(() {
                      _currentIndex = index;
                    });
                    // 탭 변경시에는 LoadNotificationsByType 사용 (전체 카운트 유지)
                    context.read<NotificationBloc>().add(
                      LoadNotificationsByType(type: types[index]),
                    );
                  },
                ),
                const SizedBox(height: 8),
                Expanded(child: _buildNotificationList(state)),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildNotificationList(NotificationState state) {
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
      final dateKeys = grouped.keys.toList()..sort((a, b) => b.compareTo(a));

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
                    onReadStatusChanged: () {
                      // 읽음 처리 반영을 위한 데이터 재로드
                      context.read<NotificationBloc>().add(
                        LoadNotificationsByType(type: types[_currentIndex]),
                      );
                      // 읽음 처리 후 현재 타입의 카운트만 업데이트
                      _updateCurrentTypeCount();
                    },
                    read: n.isRead,
                    id: n.id,
                    parentId: n.parentId,
                    type: n.type,
                    profile: n.authorImage,
                    headline: n.header,
                    title: n.plainTitle,
                    body: n.plainContent ?? n.body,
                    time: n.formattedTime,
                  );
                },
                separatorBuilder: (context, notifIndex) =>
                    Divider(height: 1, color: OrmeeColor.gray[20]),
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
  }
}
