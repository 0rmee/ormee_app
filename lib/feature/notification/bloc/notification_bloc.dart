import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ormee_app/feature/notification/bloc/notification_event.dart';
import 'package:ormee_app/feature/notification/bloc/notification_state.dart';
import 'package:ormee_app/feature/notification/data/repository.dart';
import 'package:ormee_app/feature/notification/data/utils.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository repository;

  NotificationBloc({required this.repository}) : super(NotificationLoading()) {
    on<LoadNotifications>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await repository.fetchNotifications(
          type: event.type,
        );
        final grouped = groupByDate(notifications);
        emit(NotificationLoaded(groupedNotifications: grouped));
      } catch (e) {
        emit(NotificationError(message: e.toString()));
      }
    });
  }
}
