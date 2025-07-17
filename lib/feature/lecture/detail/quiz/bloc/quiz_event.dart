abstract class QuizEvent {}

class FetchQuizzes extends QuizEvent {
  final int lectureId;

  FetchQuizzes(this.lectureId);
}
