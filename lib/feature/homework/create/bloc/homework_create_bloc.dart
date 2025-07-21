import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/feature/homework/create/data/model.dart';
import 'package:ormee_app/feature/homework/create/data/repository.dart';
import 'package:ormee_app/core/network/attachment_repository.dart';
import 'homework_create_event.dart';
import 'homework_create_state.dart';

class HomeworkCreateBloc
    extends Bloc<HomeworkCreateEvent, HomeworkCreateState> {
  final HomeworkRepository repository;
  final AttachmentRepository attachmentRepository;

  HomeworkCreateBloc(this.repository, this.attachmentRepository)
    : super(HomeworkCreateState.initial()) {
    on<ContentChanged>(_onContentChanged);
    on<ImageAdded>(_onImageAdded);
    on<ImageRemoved>(_onImageRemoved);
    on<SubmitHomework>(_onSubmitHomework);
  }

  void _onContentChanged(
    ContentChanged event,
    Emitter<HomeworkCreateState> emit,
  ) {
    emit(state.copyWith(content: event.content));
  }

  void _onImageAdded(ImageAdded event, Emitter<HomeworkCreateState> emit) {
    final newImages = List<XFile>.from(state.images)..add(event.imageFile);
    emit(state.copyWith(images: newImages));
  }

  void _onImageRemoved(ImageRemoved event, Emitter<HomeworkCreateState> emit) {
    final newImages = List<XFile>.from(state.images)..removeAt(event.index);
    emit(state.copyWith(images: newImages));
  }

  Future<void> _onSubmitHomework(
    SubmitHomework event,
    Emitter<HomeworkCreateState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(error: '내용을 입력해주세요.'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, error: null, submitSuccess: false));

    try {
      List<int> fileIds = [];

      // 이미지들을 먼저 업로드
      for (XFile imageFile in state.images) {
        try {
          final file = File(imageFile.path);
          final fileId = await attachmentRepository.uploadAttachment(
            file: file,
            type: 'HOMEWORK',
          );
          fileIds.add(fileId);
        } catch (e) {
          emit(
            state.copyWith(
              isSubmitting: false,
              error: '이미지 업로드 실패: ${e.toString()}',
            ),
          );
          print(e);
          return;
        }
      }

      // 질문 등록
      final request = HomeworkRequest(content: state.content, fileIds: fileIds);

      await repository.postHomework(event.homeworkId, request);

      emit(
        state.copyWith(
          isSubmitting: false,
          submitSuccess: true,
          fileIds: fileIds,
        ),
      );
    } catch (e) {
      emit(state.copyWith(isSubmitting: false, error: e.toString()));
    }
  }
}
