import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class QuestionCreateEvent {}

class TitleChanged extends QuestionCreateEvent {
  final String title;
  TitleChanged(this.title);
}

class ContentChanged extends QuestionCreateEvent {
  final String content;
  ContentChanged(this.content);
}

class IsLockedToggled extends QuestionCreateEvent {}

class ImageAdded extends QuestionCreateEvent {
  final XFile imageFile;
  ImageAdded(this.imageFile);
}

class ImageRemoved extends QuestionCreateEvent {
  final int index;
  ImageRemoved(this.index);
}

class SubmitQuestion extends QuestionCreateEvent {
  final int lectureId;
  SubmitQuestion(this.lectureId);
}
