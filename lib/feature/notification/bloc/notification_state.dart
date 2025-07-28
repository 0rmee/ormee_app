import 'package:ormee_app/feature/notification/data/model.dart';

abstract class NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final Map<String, List<NotificationModel>> groupedNotifications;
  final int totalCount;
  final int currentTypeCount;

  NotificationLoaded({
    required this.groupedNotifications,
    this.totalCount = 0,
    this.currentTypeCount = 0,
  });

  NotificationLoaded copyWith({
    Map<String, List<NotificationModel>>? groupedNotifications,
    int? totalCount,
    int? currentTypeCount,
  }) {
    return NotificationLoaded(
      groupedNotifications: groupedNotifications ?? this.groupedNotifications,
      totalCount: totalCount ?? this.totalCount,
      currentTypeCount: currentTypeCount ?? this.currentTypeCount,
    );
  }
}

class NotificationError extends NotificationState {
  final String message;

  NotificationError({required this.message});
}
