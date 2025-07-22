import 'dart:io';
import 'package:image_picker/image_picker.dart';

class HomeworkCreateState {
  final String content;
  final List<XFile> images;
  final List<int> fileIds;
  final bool isSubmitting;
  final bool submitSuccess;
  final String? error;

  HomeworkCreateState({
    required this.content,
    required this.images,
    required this.fileIds,
    this.isSubmitting = false,
    this.submitSuccess = false,
    this.error,
  });

  factory HomeworkCreateState.initial() =>
      HomeworkCreateState(content: '', images: [], fileIds: []);

  HomeworkCreateState copyWith({
    String? content,
    List<XFile>? images,
    List<int>? fileIds,
    bool? isSubmitting,
    bool? submitSuccess,
    String? error,
  }) {
    return HomeworkCreateState(
      content: content ?? this.content,
      images: images ?? this.images,
      fileIds: fileIds ?? this.fileIds,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      submitSuccess: submitSuccess ?? this.submitSuccess,
      error: error,
    );
  }

  // 유효성 검사
  bool get isValid => content.trim().isNotEmpty || images.isNotEmpty;
}
