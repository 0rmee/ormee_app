import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_bloc.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_event.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_state.dart';
import 'package:ormee_app/feature/question/create/presentation/widgets/content_textfield.dart';
import 'package:ormee_app/feature/question/create/presentation/widgets/title_textfield.dart';
import 'package:ormee_app/feature/question/create/data/repository.dart';
import 'package:ormee_app/feature/question/create/data/remote_datasource.dart';
import 'package:ormee_app/core/network/attachment_repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet_image.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/temp_image_viewer.dart';
import 'package:ormee_app/shared/widgets/toast.dart';
import 'package:http/http.dart' as http;

class QuestionCreate extends StatefulWidget {
  final int lectureId;
  QuestionCreate({super.key, required this.lectureId});

  @override
  State<QuestionCreate> createState() => _QuestionCreateState();
}

class _QuestionCreateState extends State<QuestionCreate> {
  Future<void> _pickImage(BuildContext context, ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 10 * 1024 * 1024) {
        OrmeeToast.show(context, '파일 크기가 10MB를 초과합니다.');
        return;
      }

      // 현재 선택된 이미지들의 총 크기 계산
      final currentImages = context.read<QuestionCreateBloc>().state.images;
      int totalSize = fileSize;
      for (XFile image in currentImages) {
        final existingFile = File(image.path);
        totalSize += await existingFile.length();
      }

      if (totalSize > 50 * 1024 * 1024) {
        OrmeeToast.show(context, '총 파일 크기가 50MB를 초과합니다.');
        return;
      }

      // BLoC에 이미지 추가
      context.read<QuestionCreateBloc>().add(ImageAdded(pickedFile));
    }
  }

  void _showImagePopupMenu(BuildContext context) async {
    await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        20,
        MediaQuery.of(context).size.height - 200,
        20,
        100,
      ),
      popUpAnimationStyle: AnimationStyle.noAnimation,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
      elevation: 3,
      color: OrmeeColor.white,
      shadowColor: Color(0xFF464854).withOpacity(0.1),
      items: <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: 'camera',
          child: Headline2Regular16(text: '카메라'),
        ),
        PopupMenuItem<String>(
          value: 'gallery',
          child: Headline2Regular16(text: '갤러리'),
        ),
      ],
    ).then((String? value) {
      if (value == 'camera') {
        _pickImage(context, ImageSource.camera);
      } else if (value == 'gallery') {
        _pickImage(context, ImageSource.gallery);
      }
    });
  }

  void _handleSubmit(BuildContext context) {
    final bloc = context.read<QuestionCreateBloc>();
    final state = bloc.state;

    // 제목이나 내용이 비어있는지 확인
    if (state.title.trim().isEmpty || state.content.trim().isEmpty) {
      OrmeeToast.show(context, '제목과 내용을 모두 입력해주세요.');
      return;
    }

    // 이미 제출 중이면 중복 실행 방지
    if (state.isSubmitting) {
      print('이미 제출 중입니다.');
      return;
    }

    // 이벤트 전송
    bloc.add(SubmitQuestion(widget.lectureId));
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionCreateBloc(
        QuestionRepository(QuestionCreateRemoteDataSource(http.Client())),
        AttachmentRepository(),
      ),
      child: BlocListener<QuestionCreateBloc, QuestionCreateState>(
        listener: (context, state) {
          if (state.submitSuccess) {
            OrmeeToast.show(context, '질문이 등록되었습니다.');
            context.pop();
          } else if (state.error != null) {
            OrmeeToast.show(context, state.error!);
          }
        },
        child: BlocBuilder<QuestionCreateBloc, QuestionCreateState>(
          builder: (context, state) {
            return SafeArea(
              child: Scaffold(
                appBar: OrmeeAppBar(
                  title: '질문',
                  isLecture: false,
                  isImage: false,
                  isDetail: false,
                  isPosting: true,
                  postAction: () => _handleSubmit(context),
                ),
                body: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  child: Column(
                    children: [
                      TitleTextField(),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
                        child: Divider(height: 1, color: OrmeeColor.gray[20]),
                      ),
                      Column(
                        children: [
                          ContentTextField(),
                          if (state.images.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: GridView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: state.images.length,
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1,
                                      childAspectRatio: 1.94 / 1,
                                      mainAxisSpacing: 8,
                                    ),
                                itemBuilder: (context, index) {
                                  final file = File(state.images[index].path);
                                  return TempImageViewer(
                                    imageFile: file,
                                    onRemove: () {
                                      context.read<QuestionCreateBloc>().add(
                                        ImageRemoved(index),
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          SizedBox(height: 65),
                        ],
                      ),
                      // 로딩 인디케이터 표시
                      if (state.isSubmitting)
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              CircularProgressIndicator(),
                              SizedBox(height: 10),
                              Text('질문을 등록 중입니다...'),
                            ],
                          ),
                        ),
                    ],
                  ),
                ),
                bottomSheet: OrmeeBottomSheetImage(
                  isQuestion: true,
                  isSecret: state.isLocked,
                  // 그리고 호출 부분을 다음과 같이 변경:
                  onImagePick: () => _showImagePopupMenu(context),
                  onSecretToggle: () {
                    context.read<QuestionCreateBloc>().add(IsLockedToggled());
                  },
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
