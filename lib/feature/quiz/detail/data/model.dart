class QuizResponse {
  final String status;
  final int code;
  final QuizData data;

  QuizResponse({required this.status, required this.code, required this.data});

  factory QuizResponse.fromJson(Map<String, dynamic> json) {
    return QuizResponse(
      status: json['status'],
      code: json['code'],
      data: QuizData.fromJson(json['data']),
    );
  }
}

class QuizData {
  final Author author;
  final String title;
  final String description;
  final String openTime;
  final String dueTime;
  final int timeLimit;
  final List<Problem> problems;
  final bool opened;
  final bool submitted;

  QuizData({
    required this.author,
    required this.title,
    required this.description,
    required this.openTime,
    required this.dueTime,
    required this.timeLimit,
    required this.problems,
    required this.opened,
    required this.submitted,
  });

  factory QuizData.fromJson(Map<String, dynamic> json) {
    return QuizData(
      author: Author.fromJson(json['author']),
      title: json['title'],
      description: json['description'],
      openTime: json['openTime'],
      dueTime: json['dueTime'],
      timeLimit: json['timeLimit'],
      problems: (json['problems'] as List)
          .map((problem) => Problem.fromJson(problem))
          .toList(),
      opened: json['opened'],
      submitted: json['submitted'],
    );
  }

  // Detail 페이지용 데이터 추출
  QuizDetail get detailInfo => QuizDetail(
    author: author,
    title: title,
    description: description,
    openTime: openTime,
    dueTime: dueTime,
    timeLimit: timeLimit,
    submitted: submitted,
  );

  // Take 페이지용 데이터 추출
  QuizTake get takeInfo => QuizTake(problems: problems, opened: opened);
}

class Author {
  final String name;
  final String image;

  Author({required this.name, required this.image});

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(name: json['name'], image: json['image']);
  }
}

class Problem {
  final int id;
  final String content;
  final ProblemType type;
  final String answer;
  final List<String> items;
  final List<int> fileIds;
  final List<String> filePaths;
  final String? submission;
  final bool? isCorrect;

  Problem({
    required this.id,
    required this.content,
    required this.type,
    required this.answer,
    required this.items,
    required this.fileIds,
    required this.filePaths,
    this.submission,
    this.isCorrect,
  });

  factory Problem.fromJson(Map<String, dynamic> json) {
    return Problem(
      id: json['id'],
      content: json['content'],
      type: ProblemType.fromString(json['type']),
      answer: json['answer'],
      items: (json['items'] as List).cast<String>(),
      fileIds: (json['fileIds'] as List).cast<int>(),
      filePaths: (json['filePaths'] as List).cast<String>(),
      submission: json['submission'],
      isCorrect: json['isCorrect'],
    );
  }

  Problem copyWith({
    int? id,
    String? content,
    ProblemType? type,
    String? answer,
    List<String>? items,
    List<int>? fileIds,
    List<String>? filePaths,
    String? submission,
    bool? isCorrect,
  }) {
    return Problem(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      answer: answer ?? this.answer,
      items: items ?? this.items,
      fileIds: fileIds ?? this.fileIds,
      filePaths: filePaths ?? this.filePaths,
      submission: submission ?? this.submission,
      isCorrect: isCorrect ?? this.isCorrect,
    );
  }
}

enum ProblemType {
  choice,
  essay;

  static ProblemType fromString(String type) {
    switch (type.toUpperCase()) {
      case 'CHOICE':
        return ProblemType.choice;
      case 'ESSAY':
        return ProblemType.essay;
      default:
        throw ArgumentError('Unknown problem type: $type');
    }
  }

  String get displayName {
    switch (this) {
      case ProblemType.choice:
        return '객관식';
      case ProblemType.essay:
        return '주관식';
    }
  }
}

// Detail 페이지용 모델
class QuizDetail {
  final Author author;
  final String title;
  final String description;
  final String openTime;
  final String dueTime;
  final int timeLimit;
  final bool submitted;

  QuizDetail({
    required this.author,
    required this.title,
    required this.description,
    required this.openTime,
    required this.dueTime,
    required this.timeLimit,
    required this.submitted,
  });

  // 시간 관련 유틸리티 메서드들
  DateTime get openDateTime => DateTime.parse(openTime);
  DateTime get dueDateTime => DateTime.parse(dueTime);

  bool get isOpen => DateTime.now().isAfter(openDateTime);
  bool get isExpired => DateTime.now().isAfter(dueDateTime);
  bool get hasTimeLimit => timeLimit > 0;

  Duration get remainingTime => dueDateTime.difference(DateTime.now());
  Duration get timeLimitDuration => Duration(minutes: timeLimit);
}

// Take 페이지용 모델
class QuizTake {
  final List<Problem> problems;
  final bool opened;

  QuizTake({required this.problems, required this.opened});

  int get totalProblems => problems.length;
  int get choiceProblems =>
      problems.where((p) => p.type == ProblemType.choice).length;
  int get essayProblems =>
      problems.where((p) => p.type == ProblemType.essay).length;

  List<Problem> get submittedProblems =>
      problems.where((p) => p.submission != null).toList();
  int get submittedCount => submittedProblems.length;

  double get progressPercentage =>
      totalProblems > 0 ? (submittedCount / totalProblems) * 100 : 0;
}

// 퀴즈 결과 모델
class QuizResultResponse {
  final String status;
  final int code;
  final QuizResultData data;

  QuizResultResponse({
    required this.status,
    required this.code,
    required this.data,
  });

  factory QuizResultResponse.fromJson(Map<String, dynamic> json) {
    return QuizResultResponse(
      status: json['status'],
      code: json['code'],
      data: QuizResultData.fromJson(json['data']),
    );
  }
}

class QuizResultData {
  final int correct;
  final List<ProblemResult> problemDtos;

  QuizResultData({required this.correct, required this.problemDtos});

  factory QuizResultData.fromJson(Map<String, dynamic> json) {
    return QuizResultData(
      correct: json['correct'],
      problemDtos: (json['problemDtos'] as List)
          .map((problem) => ProblemResult.fromJson(problem))
          .toList(),
    );
  }

  int get totalProblems => problemDtos.length;
  int get incorrect => totalProblems - correct;
  double get scorePercentage =>
      totalProblems > 0 ? (correct / totalProblems) * 100 : 0;

  List<ProblemResult> get correctProblems =>
      problemDtos.where((p) => p.isCorrect == true).toList();
  List<ProblemResult> get incorrectProblems =>
      problemDtos.where((p) => p.isCorrect == false).toList();
}

class ProblemResult {
  final int id;
  final String content;
  final ProblemType type;
  final String answer;
  final List<String> items;
  final List<int>? fileIds;
  final List<String>? filePaths;
  final String? submission;
  final bool? isCorrect;

  ProblemResult({
    required this.id,
    required this.content,
    required this.type,
    required this.answer,
    required this.items,
    this.fileIds,
    this.filePaths,
    this.submission,
    this.isCorrect,
  });

  factory ProblemResult.fromJson(Map<String, dynamic> json) {
    return ProblemResult(
      id: json['id'],
      content: json['content'],
      type: ProblemType.fromString(json['type']),
      answer: json['answer'],
      items: (json['items'] as List).cast<String>(),
      fileIds: json['fileIds'] != null
          ? (json['fileIds'] as List).cast<int>()
          : null,
      filePaths: json['filePaths'] != null
          ? (json['filePaths'] as List).cast<String>()
          : null,
      submission: json['submission'],
      isCorrect: json['isCorrect'],
    );
  }
}

// 퀴즈 제출용 모델
class QuizSubmissionRequest {
  final List<ProblemSubmission> submissions;

  QuizSubmissionRequest({required this.submissions});

  List<Map<String, dynamic>> toJson() {
    return submissions.map((submission) => submission.toJson()).toList();
  }
}

class ProblemSubmission {
  final int problemId;
  final String content;

  ProblemSubmission({required this.problemId, required this.content});

  Map<String, dynamic> toJson() {
    return {'problemId': problemId, 'content': content};
  }
}
