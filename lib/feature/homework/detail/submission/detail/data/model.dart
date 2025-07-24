class HomeworkSubmissionDetailModel {
  final String name;
  final String content;
  final List<String> filePaths;
  final DateTime createdAt;

  HomeworkSubmissionDetailModel({
    required this.name,
    required this.content,
    required this.filePaths,
    required this.createdAt,
  });

  factory HomeworkSubmissionDetailModel.fromJson(Map<String, dynamic> json) {
    return HomeworkSubmissionDetailModel(
      name: json['data']['name'] ?? '',
      content: json['data']['content'] ?? '',
      filePaths: List<String>.from(json['data']['filePaths'] ?? []),
      createdAt: DateTime.parse(json['data']['createdAt'])
    );
  }
}
