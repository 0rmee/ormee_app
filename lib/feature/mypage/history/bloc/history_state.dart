import 'package:ormee_app/feature/mypage/history/data/model.dart';

abstract class LectureHistoryState {}

class LectureHistoryInitial extends LectureHistoryState {}

class LectureHistoryLoading extends LectureHistoryState {}

class LectureHistoryLoaded extends LectureHistoryState {
  final List<LectureHistory> openLectures;
  final List<LectureHistory> closedLectures;

  LectureHistoryLoaded({
    required this.openLectures,
    required this.closedLectures,
  });
}

class LectureHistoryError extends LectureHistoryState {
  final String message;

  LectureHistoryError({required this.message});
}
