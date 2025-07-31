class Notice {
  final int id;
  final String author;
  final String title;
  final DateTime postDate;
  final bool isPinned;
  final int likes;

  Notice({
    required this.id,
    required this.author,
    required this.title,
    required this.postDate,
    required this.isPinned,
    required this.likes,
  });

  factory Notice.fromJson(Map<String, dynamic> json) {
    return Notice(
      id: json['id'],
      author: json['author'],
      title: json['title'],
      postDate: DateTime.parse(json['postDate']),
      isPinned: json['isPinned'],
      likes: json['likes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'title': title,
      'postDate': postDate.toIso8601String(),
      'isPinned': isPinned,
      'likes': likes,
    };
  }
}

class NoticeSearchResponse {
  final String status;
  final int code;
  final List<Notice> data;

  NoticeSearchResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory NoticeSearchResponse.fromJson(Map<String, dynamic> json) {
    return NoticeSearchResponse(
      status: json['status'],
      code: json['code'],
      data: (json['data'] as List)
          .map((item) => Notice.fromJson(item))
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
