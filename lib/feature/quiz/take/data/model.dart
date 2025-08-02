class QuizCard {
  final String id;
  final String content;
  final String type;
  final String answer;
  final List<String?> items;
  final List<String?> filePaths;
  final String? submission;
  final bool? isCorrect;

  QuizCard({
    required this.id,
    required this.content,
    required this.type,
    required this.answer,
    required this.items,
    required this.filePaths,
    this.submission,
    this.isCorrect,
  });

  factory QuizCard.fromJson(Map<String, dynamic> json) {
    return QuizCard(
      id: json['id'].toString(),
      content: json['content'],
      type: json['type'],
      answer: json['answer'],
      items: List<String>.from(json['items'] ?? []),
      filePaths: List<String>.from(json['filePaths'] ?? []),
      submission: json['submission'],
      isCorrect: json['isCorrect'],
    );
  }
}

class QuizSubmission {
  final List<Map<String, dynamic>> submissions;

  QuizSubmission({required this.submissions});

  Map<String, dynamic> toJson() => {'submissions': submissions};
}
