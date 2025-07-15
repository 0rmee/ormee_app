import 'package:intl/intl.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_model.dart';

class LectureHome {
  final int id;
  final String? name;
  final String? profileImage;
  final List<CoTeacher> coTeachers;
  final String title;
  final String? description;
  final String? startDate;
  final String? dueDate;

  LectureHome({
    required this.id,
    this.name,
    this.profileImage,
    required this.coTeachers,
    required this.title,
    this.description,
    required this.startDate,
    required this.dueDate,
  });

  factory LectureHome.fromJson(Map<String, dynamic> json) {
    String? formatDate(String? dateStr) {
      if (dateStr == null) return null;
      try {
        final dateTime = DateTime.parse(dateStr);
        return DateFormat('yyyy.MM.dd').format(dateTime);
      } catch (e) {
        return null;
      }
    }

    return LectureHome(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      coTeachers: json['coTeachers'] != null
          ? (json['coTeachers'] as List)
                .map((e) => CoTeacher.fromJson(e))
                .toList()
          : [],
      title: json['title'],
      description: json['description'],
      startDate: formatDate(json['startDate']),
      dueDate: formatDate(json['dueDate']),
    );
  }
}
