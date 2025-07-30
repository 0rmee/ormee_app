import 'package:intl/intl.dart';
import 'package:html/parser.dart' as html_parser;

class NotificationModel {
  final int id;
  final String? authorImage;
  final String type;
  final int parentId;
  final String header;
  final String title;
  final String body;
  final String? content;
  final bool isRead;
  final String createdAt; // ISO8601 문자열 그대로 저장

  NotificationModel({
    required this.id,
    required this.authorImage,
    required this.type,
    required this.parentId,
    required this.header,
    required this.title,
    required this.body,
    required this.content,
    required this.isRead,
    required this.createdAt,
  });

  /// content의 HTML 태그를 제거한 텍스트
  String? get plainContent {
    if (content == null || content!.trim().isEmpty) return null;

    final document = html_parser.parse(content);
    final text = document.body?.text.trim();

    if (text == null || text.isEmpty) {
      return null;
    }
    return text;
  }

  String get plainTitle {
    //if (title == null || title!.trim().isEmpty) return null;

    final document = html_parser.parse(title);
    final text = document.body?.text.trim();

    if (text == null || text.isEmpty) {
      return "";
    }
    return text;
  }

  /// createdAt을 DateTime으로 변환
  DateTime get createdAtDateTime => DateTime.parse(createdAt).toLocal();

  /// 화면에 표시할 시간 포맷
  String get formattedTime {
    final formatter = DateFormat('a h:mm', 'ko');
    return formatter.format(createdAtDateTime);
  }

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'],
      authorImage: json['authorImage'],
      type: json['type'],
      parentId: json['parentId'],
      header: json['header'],
      title: json['title'],
      body: json['body'],
      content: json['content'],
      isRead: json['isRead'],
      createdAt: json['createdAt'],
    );
  }
}

class NotificationResponse {
  final String status;
  final int code;
  final int count;
  final List<NotificationModel> notifications;

  NotificationResponse({
    required this.status,
    required this.code,
    required this.count,
    required this.notifications,
  });

  factory NotificationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];
    final List<dynamic> list = data['notifications'] ?? [];
    return NotificationResponse(
      status: json['status'],
      code: json['code'],
      count: data['count'],
      notifications: list.map((e) => NotificationModel.fromJson(e)).toList(),
    );
  }
}
