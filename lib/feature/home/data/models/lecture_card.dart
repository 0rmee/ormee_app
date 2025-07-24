import 'package:intl/intl.dart';

class LectureCard {
  final int id;
  final String title;
  final List<String> days; // ["MON", "WED"]
  final String startTime; // "15:30:00"
  final String endTime; // "17:00:00"
  final String startDate; // "2025-06-03T00:00:00"
  final String dueDate; // "2026-08-29T23:59:59"

  LectureCard({
    required this.id,
    required this.title,
    required this.days,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.dueDate,
  });

  factory LectureCard.fromJson(Map<String, dynamic> json) {
    String formatDate(String dateStr) {
      try {
        final dateTime = DateTime.parse(dateStr);
        return DateFormat('yyyy.MM.dd').format(dateTime);
      } catch (e) {
        return '';
      }
    }

    return LectureCard(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      days:
          (json['lectureDays'] as List?) // JSON의 lectureDays를 days로 매핑
              ?.map((e) => e.toString())
              .toList() ??
          [],
      startTime: json['startTime'] ?? '',
      endTime: json['endTime'] ?? '',
      startDate: formatDate(json['startDate'] ?? ''),
      dueDate: formatDate(json['dueDate'] ?? ''),
    );
  }
}
