class MemoModel {
  final int id;
  final String author;
  final String? authorImage;
  final String title;
  final String? submission;
  final DateTime dueTime;
  MemoModel({
    required this.id,
    required this.author,
    this.authorImage,
    required this.title,
    required this.submission,
    required this.dueTime,
  });
  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      id: json['id'],
      author: json['author'],
      authorImage: json['authorImage'],
      title: json['title'],
      submission: json['submission'],
      dueTime: DateTime.parse(json['dueTime']),
    );
  }
}
