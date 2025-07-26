import 'package:ormee_app/core/model/author.dart';

class AnswerDetailModel {
  final AuthorModel author;
  final String content;
  final List<String> filePaths;
  final DateTime createdAt;

  AnswerDetailModel({
    required this.content,
    required this.author,
    required this.filePaths,
    required this.createdAt,
  });

  factory AnswerDetailModel.fromJson(Map<String, dynamic> json) {
    return AnswerDetailModel(
      author: AuthorModel.fromValue(
        json['data']['teacherName'] ?? '',
        json['data']['teacherImage'],
      ),
      content: json['data']['content'] ?? "",
      filePaths: List<String>.from(json['data']['filePaths'] ?? []),
      createdAt: DateTime.parse(json['data']['createdAt']),
    );
  }
}