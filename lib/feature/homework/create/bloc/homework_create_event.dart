import 'dart:io';
import 'package:image_picker/image_picker.dart';

abstract class HomeworkCreateEvent {}

class ContentChanged extends HomeworkCreateEvent {
  final String content;
  ContentChanged(this.content);
}

class ImageAdded extends HomeworkCreateEvent {
  final XFile imageFile;
  ImageAdded(this.imageFile);
}

class ImageRemoved extends HomeworkCreateEvent {
  final int index;
  ImageRemoved(this.index);
}

class SubmitHomework extends HomeworkCreateEvent {
  final int homeworkId;
  SubmitHomework(this.homeworkId);
}
