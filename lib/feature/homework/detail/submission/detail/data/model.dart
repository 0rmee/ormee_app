class HomeworkSubmissionDetailModel {
  final int id;
  final String name;
  final String content;
  final List<String> filePaths;
  final DateTime createdAt;

  HomeworkSubmissionDetailModel({
    required this.id,
    required this.name,
    required this.content,
    required this.filePaths,
    required this.createdAt,
  });

  factory HomeworkSubmissionDetailModel.fromJson(Map<String, dynamic> json) {
    return HomeworkSubmissionDetailModel(
      id: json['data']['id'] ?? 0,
      name: json['data']['name'] ?? '',
      content: json['data']['content'] ?? '',
      filePaths: List<String>.from(json['data']['filePaths'] ?? []),
      createdAt: DateTime.parse(json['data']['createdAt'])
    );
  }
}
