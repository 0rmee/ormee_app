class LectureModel {
  final int id;
  final String name;
  final String? profileImage;
  final List<CoTeacher> coTeachers;
  final String title;
  final String? description;
  final List<String> lectureDays;
  final String startTime;
  final String endTime;
  final String? startDate;
  final String? dueDate;
  final bool messageAvailable;

  LectureModel({
    required this.id,
    required this.name,
    this.profileImage,
    required this.coTeachers,
    required this.title,
    this.description,
    required this.lectureDays,
    required this.startTime,
    required this.endTime,
    this.startDate,
    this.dueDate,
    required this.messageAvailable,
  });

  factory LectureModel.fromJson(Map<String, dynamic> json) {
    return LectureModel(
      id: json['id'],
      name: json['name'],
      profileImage: json['profileImage'],
      coTeachers: (json['coTeachers'] as List)
          .map((e) => CoTeacher.fromJson(e))
          .toList(),
      title: json['title'],
      description: json['description'],
      lectureDays: List<String>.from(json['lectureDays']),
      startTime: json['startTime'],
      endTime: json['endTime'],
      startDate: json['startDate'],
      dueDate: json['dueDate'],
      messageAvailable: json['messageAvailable'],
    );
  }

  String get formattedStartTime => startTime.substring(0, 5);
  String get formattedEndTime => endTime.substring(0, 5);
}

class CoTeacher {
  final String name;
  final String? image;

  CoTeacher({required this.name, this.image});

  factory CoTeacher.fromJson(Map<String, dynamic> json) {
    return CoTeacher(name: json['name'], image: json['image']);
  }
}
