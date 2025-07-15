import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

// 카메라 촬영 함수
Future<void> pickImageFromCamera(BuildContext context) async {
  final picker = ImagePicker();
  final XFile? photo = await picker.pickImage(source: ImageSource.camera);

  if (photo != null) {
    // TODO: QR인식시 연결 API 추가
  }
}
