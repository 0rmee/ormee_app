class Notification {
  final int id;
  final String? authorImage; // null 허용
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
    this.authorImage, // null 허용으로 변경
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
    try {
      return Notification(
        id: json['id'] ?? 0,
        authorImage: json['authorImage'], // null 그대로 허용
        type: json['type'] ?? '',
        parentId: json['parentId'] ?? 0,
        header: json['header'] ?? '',
        title: json['title'] ?? '',
        body: json['body'] ?? '',
        content: json['content'] ?? '',
        isRead: json['isRead'] ?? false,
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : DateTime.now(),
      );
    } catch (e) {
      print('NotificationModel 파싱 에러: $e');
      print('JSON 데이터: $json');
      throw Exception('NotificationModel 파싱 실패: $e');
    }
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
      'createdAt': createdAt.toIso8601String(),
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
    try {
      final dataList = json['data'] as List;
      final notifications = <Notification>[];

      for (int i = 0; i < dataList.length; i++) {
        try {
          final notification = Notification.fromJson(dataList[i]);
          notifications.add(notification);
        } catch (e) {
          print('알림 $i 파싱 실패: $e'); // 디버깅용
          print('실패한 데이터: ${dataList[i]}'); // 디버깅용
          // 개별 알림 파싱 실패 시에도 계속 진행
        }
      }

      return NotificationSearchResponse(
        status: json['status'] ?? 'unknown',
        code: json['code'] ?? 0,
        data: notifications,
      );
    } catch (e) {
      print('NotificationSearchResponse 파싱 에러: $e'); // 디버깅용
      throw Exception('NotificationSearchResponse 파싱 실패: $e');
    }
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
