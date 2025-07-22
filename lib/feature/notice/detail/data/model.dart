import 'package:ormee_app/shared/utils/file_utils.dart';

class NoticeDetailModel {
  final String title;
  final String description;
  final DateTime postDate;
  bool isLiked;
  final AuthorModel author;

  final List<String> imageUrls;
  final List<NoticeFile> attachmentFiles;

  NoticeDetailModel({
    required this.title,
    required this.description,
    required this.postDate,
    required this.isLiked,
    required this.author,
    required this.imageUrls,
    required this.attachmentFiles,
  });

  factory NoticeDetailModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> fileNames = json['data']['fileNames'] ?? [];
    final List<dynamic> filePaths = json['data']['filePaths'] ?? [];

    List<String> images = [];
    List<NoticeFile> files = [];

    for (int i = 0; i < filePaths.length; i++) {
      final url = filePaths[i] as String;
      final name = fileNames.length > i ? fileNames[i] as String : '파일';

      if (FileUtil.isImageFile(url)) {
        images.add(url);
      } else {
        files.add(NoticeFile(name: name, url: url));
      }
    }

    return NoticeDetailModel(
      title: json['data']['title'] ?? '',
      description: json['data']['description'] ?? '',
      postDate: json['data']['postDate'] ?? '',
      isLiked: json['data']['isLiked'] ?? false,
      author: AuthorModel.fromJson(json['data']['author'] ?? {}),
      imageUrls: images,
      attachmentFiles: files,
    );
  }
}

class NoticeFile {
  final String name;
  final String url;

  NoticeFile({required this.name, required this.url});
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
