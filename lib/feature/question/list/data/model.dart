class QuestionListModel {
  final int id;
  final String title;
  final bool isLocked;
  final bool isAnswered;
  final bool isMine;
  final String author;
  final DateTime createdAt;

  QuestionListModel({
    required this.id,
    required this.title,
    required this.isLocked,
    required this.isAnswered,
    required this.isMine,
    required this.author,
    required this.createdAt,
  });

  factory QuestionListModel.fromJson(Map<String, dynamic> json) {
    return QuestionListModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      isLocked: json['isLocked'] ?? false,
      isAnswered: json['isAnswered'] ?? false,
      isMine: json['isMine'] ?? false,
      author: json['author'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}