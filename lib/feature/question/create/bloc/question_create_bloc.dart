import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/feature/question/create/data/model.dart';
import 'package:ormee_app/feature/question/create/data/repository.dart';
import 'package:ormee_app/core/network/attachment_repository.dart';
import 'question_create_event.dart';
import 'question_create_state.dart';

class QuestionCreateBloc
    extends Bloc<QuestionCreateEvent, QuestionCreateState> {
  final QuestionRepository repository;
  final AttachmentRepository attachmentRepository;

  QuestionCreateBloc(this.repository, this.attachmentRepository)
    : super(QuestionCreateState.initial()) {
    on<TitleChanged>(_onTitleChanged);
    on<ContentChanged>(_onContentChanged);
    on<IsLockedToggled>(_onIsLockedToggled);
    on<ImageAdded>(_onImageAdded);
    on<ImageRemoved>(_onImageRemoved);
    on<SubmitQuestion>(_onSubmitQuestion);
  }

  void _onTitleChanged(TitleChanged event, Emitter<QuestionCreateState> emit) {
    final newTitle = event.title.length <= 20
        ? event.title
        : event.title.substring(0, 20);
    emit(state.copyWith(title: newTitle));
  }

  void _onContentChanged(
    ContentChanged event,
    Emitter<QuestionCreateState> emit,
  ) {
    emit(state.copyWith(content: event.content));
  }

  void _onIsLockedToggled(
    IsLockedToggled event,
    Emitter<QuestionCreateState> emit,
  ) {
    emit(state.copyWith(isLocked: !state.isLocked));
  }

  void _onImageAdded(ImageAdded event, Emitter<QuestionCreateState> emit) {
    final newImages = List<XFile>.from(state.images)..add(event.imageFile);
    emit(state.copyWith(images: newImages));
  }

  void _onImageRemoved(ImageRemoved event, Emitter<QuestionCreateState> emit) {
    final newImages = List<XFile>.from(state.images)..removeAt(event.index);
    emit(state.copyWith(images: newImages));
  }

  Future<void> _onSubmitQuestion(
    SubmitQuestion event,
    Emitter<QuestionCreateState> emit,
  ) async {
    if (!state.isValid) {
      emit(state.copyWith(error: '제목과 내용을 입력해주세요.'));
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
            type: 'QUESTION',
          );
          fileIds.add(fileId);
        } catch (e) {
          emit(
            state.copyWith(
              isSubmitting: false,
              error: '이미지 업로드 실패: ${e.toString()}',
            ),
          );
          return;
        }
      }

      // 질문 등록
      final request = QuestionRequest(
        isLocked: state.isLocked,
        title: state.title,
        content: state.content,
        fileIds: fileIds,
      );

      await repository.postQuestion(event.lectureId, request);

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
