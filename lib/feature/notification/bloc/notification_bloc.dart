import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/notification/bloc/notification_event.dart';
import 'package:ormee_app/feature/notification/bloc/notification_state.dart';
import 'package:ormee_app/feature/notification/data/model.dart';
import 'package:ormee_app/feature/notification/data/repository.dart';
import 'package:ormee_app/feature/notification/data/utils.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationLoading()) {
    // 초기 로드: 전체 카운트 + 알림 목록
    on<LoadNotifications>(_onLoadNotifications);

    // 탭 변경: 알림 목록만 (전체 카운트 유지)
    on<LoadNotificationsByType>(_onLoadNotificationsByType);

    // 전체 알림 개수만 로드
    on<LoadNotificationCount>(_onLoadNotificationCount);

    // 특정 타입 알림 개수만 로드
    on<LoadNotificationCountByType>(_onLoadNotificationCountByType);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());
    try {
      // 동시에 전체 카운트와 해당 타입 알림을 가져옴
      final futures = await Future.wait([
        repository.fetchNotificationCount(),
        repository.fetchNotifications(type: event.type),
      ]);

      final totalCount = futures[0] as int;
      final response = futures[1] as NotificationResponse;

      final grouped = groupByDate(response.notifications);

      emit(
        NotificationLoaded(
          groupedNotifications: grouped,
          totalCount: totalCount,
          currentTypeCount: response.count,
        ),
      );
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _onLoadNotificationsByType(
    LoadNotificationsByType event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        final response = await repository.fetchNotifications(type: event.type);
        final grouped = groupByDate(response.notifications);

        emit(
          currentState.copyWith(
            groupedNotifications: grouped,
            currentTypeCount: response.count,
          ),
        );
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    }
  }

  Future<void> _onLoadNotificationCount(
    LoadNotificationCount event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        final totalCount = await repository.fetchNotificationCount();
        emit(currentState.copyWith(totalCount: totalCount));
      } catch (e) {
        print('Failed to load total count: $e');
      }
    }
  }

  Future<void> _onLoadNotificationCountByType(
    LoadNotificationCountByType event,
    Emitter<NotificationState> emit,
  ) async {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      try {
        final response = await repository.fetchNotifications(type: event.type);
        emit(currentState.copyWith(currentTypeCount: response.count));
      } catch (e) {
        print('Failed to load type count: $e');
      }
    }
  }
}
