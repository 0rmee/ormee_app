import 'package:intl/intl.dart';
import 'package:ormee_app/feature/notification/data/model.dart';

Map<String, List<NotificationModel>> groupByDate(
  List<NotificationModel> notifications,
) {
  final Map<String, List<NotificationModel>> grouped = {};
  final dateFormatter = DateFormat('yyyy-MM-dd');

  for (var n in notifications) {
    final dateKey = dateFormatter.format(n.createdAtDateTime);
    grouped.putIfAbsent(dateKey, () => []);
    grouped[dateKey]!.add(n);
  }

  return grouped;
}

String formatKoreanDateHeader(DateTime date) {
  final formatter = DateFormat('yyyy. MM. dd (E)', 'ko');
  return formatter.format(date);
}
