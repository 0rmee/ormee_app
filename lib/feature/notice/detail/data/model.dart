class NoticeDetailModel {
  final String title;
  final String description;
  final List<String> fileNames;
  final List<String> filePaths;
  final DateTime? postDate;
  final bool isLiked;
  final int likes;
  final AuthorModel author;

  NoticeDetailModel({
    required this.title,
    required this.description,
    required this.fileNames,
    required this.filePaths,
    required this.postDate,
    required this.isLiked,
    required this.likes,
    required this.author,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    return NoticeDetailModel(
      title: json['data']['title'] ?? '',
      description: json['data']['description'] ?? '',
      fileNames: List<String>.from(json['data']['fileNames'] ?? []),
      filePaths: List<String>.from(json['data']['filePaths'] ?? []),
      postDate: json['data']['postDate'] != null
          ? DateTime.tryParse(json['data']['postDate'])
          : null,
      isLiked: json['data']['isLiked'] ?? false,
      likes: json['data']['likes'] ?? 0,
      author: AuthorModel.fromJson(json['data']['author'] ?? {}),
    );
  }
}

class AuthorModel {
  final String name;
  final String image;

  AuthorModel({
    required this.name,
    required this.image,
  });

  factory AuthorModel.fromJson(Map<String, dynamic> json) {
    return AuthorModel(
      name: json['name'] ?? '',
      image: json['image'] ?? '',
    );
  }
}
