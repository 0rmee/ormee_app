import 'package:ormee_app/feature/notification/data/model.dart';

abstract class NotificationState {
  const NotificationState();
}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final Map<String, List<NotificationModel>> groupedNotifications;

  const NotificationLoaded({required this.groupedNotifications});
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});
}
