class NoticeModel {
  final int id;
  final String author;
  final String title;
  final DateTime postDate;
  final bool isPinned;
  final int? likes;

  NoticeModel({
    required this.id,
    required this.author,
    required this.title,
    required this.postDate,
    required this.isPinned,
    this.likes,
  });

  factory NoticeModel.fromJson(Map<String, dynamic> json) {
    return NoticeModel(
      id: json['id'],
      author: json['author'],
      title: json['title'],
      postDate: DateTime.parse(json['postDate']),
      isPinned: json['isPinned'],
      likes: json['likes'],
    );
  }
}
