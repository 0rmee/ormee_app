import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/feature/question/create/bloc/question_create_bloc.dart';
import 'package:ormee_app/feature/question/create/presentation/widgets/content_textfield.dart';
import 'package:ormee_app/feature/question/create/presentation/widgets/title_textfield.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/bottomsheet_image.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/temp_image_viewer.dart';
import 'package:ormee_app/shared/widgets/toast.dart';

class QuestionCreate extends StatefulWidget {
  QuestionCreate({super.key});

  @override
  State<QuestionCreate> createState() => _QuestionCreateState();
}

class _QuestionCreateState extends State<QuestionCreate> {
  List<XFile> _images = [];
  bool _isSecret = false;

  // 이미지 선택 함수 추가
  Future<void> _pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      // 파일 크기 체크 (10MB 제한)
      final file = File(pickedFile.path);
      final fileSize = await file.length();

      if (fileSize > 10 * 1024 * 1024) {
        // 10MB
        OrmeeToast.show(context, '파일 크기가 10MB를 초과합니다.');
        return;
      }

      // 총 용량 체크 (50MB 제한)
      int totalSize = fileSize;
      for (XFile image in _images) {
        final existingFile = File(image.path);
        totalSize += await existingFile.length();
      }

      if (totalSize > 50 * 1024 * 1024) {
        // 50MB
        OrmeeToast.show(context, '총 파일 크기가 50MB를 초과합니다.');
        return;
      }

      setState(() {
        _images.add(pickedFile);
      });
    }
  }

  // 이미지 선택 옵션 다이얼로그
  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: OrmeeColor.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: OrmeeButton(
                    text: '카메라',
                    isTrue: true,
                    trueAction: () {
                      context.pop();
                      _pickImage(ImageSource.camera);
                    },
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: OrmeeButton(
                    text: '갤러리',
                    isTrue: true,
                    trueAction: () {
                      context.pop();
                      _pickImage(ImageSource.gallery);
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => QuestionCreateBloc(),
      child: SafeArea(
        child: Scaffold(
          appBar: OrmeeAppBar(
            title: '질문',
            isLecture: false,
            isImage: false,
            isDetail: false,
            isPosting: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
            child: Column(
              children: [
                // 제목 글자수 20자 제한
                TitleTextField(),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 12, 0, 16),
                  child: Divider(height: 1, color: OrmeeColor.gray[20]),
                ),
                Column(
                  children: [
                    ContentTextField(),
                    if (_images.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: GridView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: _images.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 1,
                                childAspectRatio: 1.94 / 1,
                                mainAxisSpacing: 8,
                              ),
                          itemBuilder: (context, index) {
                            final file = File(_images[index].path);
                            return TempImageViewer(
                              imageFile: file,
                              onRemove: () {
                                setState(() {
                                  _images.removeAt(index);
                                });
                              },
                            );
                          },
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
          bottomSheet: OrmeeBottomSheetImage(
            isQuestion: true,
            isSecret: _isSecret,
            onImagePick: _showImageSourceDialog, // 콜백 함수 전달
            onSecretToggle: () {
              setState(() {
                _isSecret = !_isSecret;
              });
            },
          ),
        ),
      ),
    );
  }
}
