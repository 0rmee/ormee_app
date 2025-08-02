class LectureHistoryResponse {
  final String status;
  final int code;
  final LectureHistoryData data;

  LectureHistoryResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory LectureHistoryResponse.fromJson(Map<String, dynamic> json) {
    return LectureHistoryResponse(
      status: json['status'],
      code: json['code'],
      data: LectureHistoryData.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {'status': status, 'code': code, 'data': data.toJson()};
  }
}

class LectureHistoryData {
  final List<LectureHistory> openLectures;
  final List<LectureHistory> closedLectures;

  LectureHistoryData({
    required this.openLectures,
    required this.closedLectures,
  });

  factory LectureHistoryData.fromJson(Map<String, dynamic> json) {
    return LectureHistoryData(
      openLectures: (json['openLectures'] as List)
          .map((e) => LectureHistory.fromJson(e))
          .toList(),
      closedLectures: (json['closedLectures'] as List)
          .map((e) => LectureHistory.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'openLectures': openLectures.map((e) => e.toJson()).toList(),
      'closedLectures': closedLectures.map((e) => e.toJson()).toList(),
    };
  }
}

class LectureHistory {
  final int id;
  final String? name;
  final String? profileImage;
  final List<CoTeacher>? coTeachers;
  final String? coTeacher;
  final String title;
  final String? description;
  final List<String> lectureDays;
  final String startTime;
  final String endTime;
  final String? startDate;
  final String? dueDate;
  final List<dynamic>? students;
  final List<dynamic>? quizList;
  final int? activeQuizCount;
  final bool messageAvailable;
  final bool owner;

  LectureHistory({
    required this.id,
    this.name,
    this.profileImage,
    this.coTeachers,
    this.coTeacher,
    required this.title,
    this.description,
    required this.lectureDays,
    required this.startTime,
    required this.endTime,
    this.startDate,
    this.dueDate,
    this.students,
    this.quizList,
    this.activeQuizCount,
    required this.messageAvailable,
    required this.owner,
  });

  factory LectureHistory.fromJson(Map<String, dynamic> json) {
    return LectureHistory(
      id: json['id'],
      name: json['name'],

      // profileImage: json['profileImage'],
      // coTeachers: json['coTeachers'] != null
      //     ? (json['coTeachers'] as List)
      //           .map((e) => CoTeacher.fromJson(e))
      //           .toList()
      //     : null,
      profileImage: json['profileImage'],
      coTeachers: json['coTeachers'] != null
          ? (json['coTeachers'] as List)
                .map((e) => CoTeacher.fromJson(e))
                .toList()
          : [],
      coTeacher: json['coTeacher'],
      title: json['title'],
      description: json['description'],
      lectureDays: List<String>.from(json['lectureDays']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      startDate: json['startDate'],
      dueDate: json['dueDate'],
      students: json['students'],
      quizList: json['quizList'],
      activeQuizCount: json['activeQuizCount'],
      messageAvailable: json['messageAvailable'],
      owner: json['owner'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'profileImage': profileImage,
      'coTeachers': coTeachers?.map((e) => e.toJson()).toList(),
      'coTeacher': coTeacher,
      'title': title,
      'description': description,
      'lectureDays': lectureDays,
      'startTime': startTime,
      'endTime': endTime,
      'startDate': startDate,
      'dueDate': dueDate,
      'students': students,
      'quizList': quizList,
      'activeQuizCount': activeQuizCount,
      'messageAvailable': messageAvailable,
      'owner': owner,
    };
  }
}

class CoTeacher {
  final String name;
  final String? image;

  CoTeacher({required this.name, this.image});

  factory CoTeacher.fromJson(Map<String, dynamic> json) {
    return CoTeacher(name: json['name'], image: json['image']);
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'image': image};
  }
}
