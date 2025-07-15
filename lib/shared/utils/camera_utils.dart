import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_event.dart';

// 카메라 촬영 함수
Future<void> pickImageFromCamera(BuildContext context) async {
  final picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    final int lectureId = 1; // QR에서 얻은 ID, 일단 하드코딩
    context.read<LectureHomeBloc>().add(ShowLectureDialog(lectureId));
  }
}
