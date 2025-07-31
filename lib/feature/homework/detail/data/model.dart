import 'package:ormee_app/core/model/author.dart';
import 'package:ormee_app/core/model/file_attachment.dart';
import 'package:ormee_app/shared/utils/file_utils.dart';

class HomeworkDetailModel {
  final String title;
  final String description;
  final DateTime openTime;
  final DateTime dueTime;
  final bool isSubmitted;
  final bool feedbackCompleted;
  final AuthorModel author;

  final List<String> imageUrls;
  final List<AttachmentFile> attachmentFiles;

  HomeworkDetailModel({
    required this.title,
    required this.description,
    required this.openTime,
    required this.dueTime,
    required this.isSubmitted,
    required this.feedbackCompleted,
    required this.author,
    required this.imageUrls,
    required this.attachmentFiles,
  });

  factory HomeworkDetailModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fileNames = json['data']['fileNames'] ?? [];
    final List<dynamic> filePaths = json['data']['filePaths'] ?? [];

    List<String> images = [];
    List<AttachmentFile> files = [];

    for (int i = 0; i < filePaths.length; i++) {
      final url = filePaths[i] as String;
      final name = fileNames.length > i ? fileNames[i] as String : '파일';

      if (FileUtil.isImageFile(url)) {
        images.add(url);
      } else {
        files.add(AttachmentFile(name: name, url: url));
      }
    }

    return HomeworkDetailModel(
      title: json['data']['title'] ?? '',
      description: json['data']['description'] ?? '',
      openTime: DateTime.parse(json['data']['openTime']),
      dueTime: DateTime.parse(json['data']['dueTime']),
      isSubmitted: json['data']['submitted'] ?? false,
      feedbackCompleted: json['data']['feedbackCompleted'] ?? false,
      author: AuthorModel.fromValue(
        json['data']['author'] ?? '',
        json['data']['authorImage'] ?? '',
      ),
      imageUrls: images,
      attachmentFiles: files,
    );
  }
}
