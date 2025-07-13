class HomeworkModel {
  final int id;
  final String title;
  final String author;
  final DateTime openTime;
  final DateTime dueTime;
  final bool submitted;

  HomeworkModel({
    required this.id,
    required this.title,
    required this.author,
    required this.openTime,
    required this.dueTime,
    required this.submitted,
  });

  factory HomeworkModel.fromJson(Map<String, dynamic> json) {
    return HomeworkModel(
      id: json['id'],
      title: json['title'],
      author: json['author'] ?? "null",
      openTime: DateTime.parse(json['openTime']),
      dueTime: DateTime.parse(json['dueTime']),
      submitted: json['submitted'],
    );
  }
}
