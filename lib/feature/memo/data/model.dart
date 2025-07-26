class MemoModel {
  final int id;
  final String author;
  final String? authorImage;
  final String title;
  final String? submission;
  final DateTime dueTime;
  final bool isOpen;

  MemoModel({
    required this.id,
    required this.author,
    this.authorImage,
    required this.title,
    required this.submission,
    required this.dueTime,
    required this.isOpen,
  });

  factory MemoModel.fromJson(Map<String, dynamic> json) {
    return MemoModel(
      id: json['id'],
      author: json['author'],
      authorImage: json['authorImage'],
      title: json['title'],
      submission: json['submission'],
      dueTime: DateTime.parse(json['dueTime']),
      isOpen: json['isOpen'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'authorImage': authorImage,
      'title': title,
      'submission': submission,
      'dueTime': dueTime.toIso8601String(),
      'isOpen': isOpen,
    };
  }

  MemoModel copyWith({
    int? id,
    String? author,
    String? authorImage,
    String? title,
    String? submission,
    DateTime? dueTime,
    bool? isOpen,
  }) {
    return MemoModel(
      id: id ?? this.id,
      author: author ?? this.author,
      authorImage: authorImage ?? this.authorImage,
      title: title ?? this.title,
      submission: submission ?? this.submission,
      dueTime: dueTime ?? this.dueTime,
      isOpen: isOpen ?? this.isOpen,
    );
  }
}
