import 'package:ormee_app/core/model/author.dart';

class FeedbackDetailModel {
  final String content;
  final String stamp;
  final DateTime createdAt;
  final AuthorModel author;

  FeedbackDetailModel({
    required this.content,
    required this.stamp,
    required this.createdAt,
    required this.author,
  });

  factory FeedbackDetailModel.fromJson(Map<String, dynamic> json) {
    return FeedbackDetailModel(
      content: json['content'] ?? '',
      stamp: json['stamp'] ?? '',
      createdAt: DateTime.parse(json['createdAt']),
      author: AuthorModel.fromJson(json['author'] ?? {}),
    );
  }
}