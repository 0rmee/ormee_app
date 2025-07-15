class Lecture {
  final int id;
  final String title;
  final List<String> lectureDays;
  final String startTime;
  final String endTime;
  final DateTime startDate;
  final DateTime dueDate;
  final bool messageAvailable;

  Lecture({
    required this.id,
    required this.title,
    required this.lectureDays,
    required this.startTime,
    required this.endTime,
    required this.startDate,
    required this.dueDate,
    required this.messageAvailable,
  });

  factory Lecture.fromJson(Map<String, dynamic> json) {
    return Lecture(
      id: json['id'],
      title: json['title'],
      lectureDays: List<String>.from(json['lectureDays'] ?? []),
      startTime: json['startTime'],
      endTime: json['endTime'],
      startDate: DateTime.parse(json['startDate']),
      dueDate: DateTime.parse(json['dueDate']),
      messageAvailable: json['messageAvailable'] ?? false,
    );
  }
}
