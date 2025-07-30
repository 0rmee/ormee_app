class Notification {
  final int id;
  final String authorImage;
  final String type;
  final int parentId;
  final String header;
  final String title;
  final String body;
  final String content;
  final bool isRead;
  final DateTime createdAt;

  Notification({
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

  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      id: json['id'],
      authorImage: json['authorImage'],
      type: json['type'],
      parentId: json['parentId'],
      header: json['header'],
      title: json['title'],
      body: json['body'],
      content: json['content'],
      isRead: json['isRead'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'authorImage': authorImage,
      'type': type,
      'parentId': parentId,
      'header': header,
      'title': title,
      'body': body,
      'content': content,
      'isRead': isRead,
      'createdAt': createdAt,
    };
  }
}

class NotificationSearchResponse {
  final String status;
  final int code;
  final List<Notification> data;

  NotificationSearchResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory NotificationSearchResponse.fromJson(Map<String, dynamic> json) {
    return NotificationSearchResponse(
      status: json['status'],
      code: json['code'],
      data: (json['data'] as List<dynamic>)
          .map((e) => Notification.fromJson(e))
          .toList(),
    );
  }
}

class SearchHistory {
  final String keyword;
  final DateTime searchDate;

  SearchHistory({required this.keyword, required this.searchDate});

  factory SearchHistory.fromJson(Map<String, dynamic> json) {
    return SearchHistory(
      keyword: json['keyword'],
      searchDate: DateTime.parse(json['searchDate']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'keyword': keyword, 'searchDate': searchDate.toIso8601String()};
  }
}
