import 'package:intl/intl.dart';

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
