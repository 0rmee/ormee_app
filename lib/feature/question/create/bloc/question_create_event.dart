abstract class QuestionCreateEvent {}

class TitleChanged extends QuestionCreateEvent {
  final String title;
  TitleChanged(this.title);
}
