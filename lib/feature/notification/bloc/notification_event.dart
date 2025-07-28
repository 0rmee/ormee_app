abstract class NotificationEvent {}

class LoadNotifications extends NotificationEvent {
  final String type;

  LoadNotifications({required this.type});
}

class LoadNotificationCount extends NotificationEvent {}

class LoadNotificationCountByType extends NotificationEvent {
  final String type;

  LoadNotificationCountByType({required this.type});
}

class LoadNotificationsByType extends NotificationEvent {
  final String type;

  LoadNotificationsByType({required this.type});
}
