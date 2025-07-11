class QuizModel {
  final int quizId;
  final String title;
  final String author;
  final DateTime openTime;
  final DateTime dueTime;
  final bool submitted;

  QuizModel({
    required this.quizId,
    required this.title,
    required this.author,
    required this.openTime,
    required this.dueTime,
    required this.submitted,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      quizId: json['quizId'],
      title: json['title'],
      author: json['author'] ?? 'null',
      openTime: DateTime.parse(json['openTime']),
      dueTime: DateTime.parse(json['dueTime']),
      submitted: json['submitted'],
    );
  }
}
