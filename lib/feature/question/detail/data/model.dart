class QuestionDetailModel {
  final int id;
  final String title;
  final String content;
  final bool? isLocked;
  final bool isAnswered;
  final bool? isMine;
  final String author;
  final List<String> filePaths;
  final DateTime createdAt;

  QuestionDetailModel({
    required this.id,
    required this.title,
    required this.content,
    required this.isLocked,
    required this.isAnswered,
    required this.isMine,
    required this.author,
    required this.filePaths,
    required this.createdAt,
  });

  factory QuestionDetailModel.fromJson(Map<String, dynamic> json) {
    return QuestionDetailModel(
      id: json['data']['id'] ?? 0,
      title: json['data']['title'] ?? "",
      content: json['data']['content'] ?? "",
      isLocked: json['data']['isLocked'] ?? false,
      isAnswered: json['data']['isAnswered'] ?? false,
      isMine: json['data']['isMine']  ?? false,
      author: json['data']['author'] ?? "",
      filePaths: List<String>.from(json['data']['filePaths'] ?? []),
      createdAt: json['data']['createdAt'],
    );
  }
}
