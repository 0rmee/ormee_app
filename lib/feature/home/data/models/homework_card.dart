class HomeworkCard {
  final int id;
  final String? lectureTitle;
  final String homeworkTitle;
  final String homeworkDueTime; // "2026.07.23 00:00" 그대로 둠

  HomeworkCard({
    required this.id,
    this.lectureTitle,
    required this.homeworkTitle,
    required this.homeworkDueTime,
  });

  factory HomeworkCard.fromJson(Map<String, dynamic> json) {
    return HomeworkCard(
      id: json['id'] ?? 0,
      lectureTitle: json['lectureTitle'],
      homeworkTitle: json['homeworkTitle'] ?? '',
      homeworkDueTime: json['homeworkDueTime'] ?? '',
    );
  }
}
