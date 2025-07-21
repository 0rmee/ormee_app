class HomeworkRequest {
  final String? content;
  final List<int>? fileIds;

  HomeworkRequest({required this.content, required this.fileIds});

  Map<String, dynamic> toJson() {
    return {'content': content, 'fileIds': fileIds ?? []};
  }
}
