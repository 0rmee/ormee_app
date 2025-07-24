class QuizCard {
  final int id;
  final String lectureTitle;
  final String quizTitle;
  final String quizDueTime;

  QuizCard({
    required this.id,
    required this.lectureTitle,
    required this.quizTitle,
    required this.quizDueTime,
  });

  factory QuizCard.fromJson(Map<String, dynamic> json) {
    return QuizCard(
      id: json['id'],
      lectureTitle: json['lectureTitle'],
      quizTitle: json['quizTitle'],
      quizDueTime: json['quizDueTime'],
    );
  }
}
