import 'dart:io';
import 'package:image_picker/image_picker.dart';

class QuestionCreateState {
  final String title;
  final String content;
  final bool isLocked;
  final List<XFile> images;
  final List<int> fileIds;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? error;

  QuestionCreateState({
    required this.title,
    required this.content,
    required this.isLocked,
    required this.images,
    required this.fileIds,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.error,
  });

  factory QuestionCreateState.initial() => QuestionCreateState(
    title: '',
    content: '',
    isLocked: false,
    images: [],
    fileIds: [],
  );

  QuestionCreateState copyWith({
    String? title,
    String? content,
    bool? isLocked,
    List<XFile>? images,
    List<int>? fileIds,
    bool? isSubmitting,
    bool? submitSuccess,
    String? error,
  }) {
    return QuestionCreateState(
      title: title ?? this.title,
      content: content ?? this.content,
      isLocked: isLocked ?? this.isLocked,
      images: images ?? this.images,
      fileIds: fileIds ?? this.fileIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      error: error,
    );
  }

  // 유효성 검사
  bool get isValid => title.trim().isNotEmpty && content.trim().isNotEmpty;
}
