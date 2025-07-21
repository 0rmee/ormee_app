class QuestionRequest {
  final bool isLocked;
  final String title;
  final String content;
  final List<int> fileIds;

  QuestionRequest({
    required this.isLocked,
    required this.title,
    required this.content,
    required this.fileIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'isLocked': isLocked,
      'title': title,
      'content': content,
      'fileIds': fileIds,
    };
  }
}
