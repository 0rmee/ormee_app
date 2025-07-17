import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
/*
List<XFile> _images = [];

@override
Widget build(BuildContext context) {
  return GridView.builder(
    itemCount: _images.length,
    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
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
  );
}
*/

class TempImageViewer extends StatelessWidget {
  final File imageFile;
  final VoidCallback onRemove;

  const TempImageViewer({
    super.key,
    required this.imageFile,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.topRight,
      children: [
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(width: 1, color: OrmeeColor.gray[10]!),
            image: DecorationImage(
              fit: BoxFit.cover,
              image: FileImage(imageFile),
            ),
          ),
        ),
        GestureDetector(
          onTap: onRemove,
          child: Container(
            width: 20,
            height: 20,
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SvgPicture.asset('assets/icons/xCircle.svg'),
          ),
        ),
      ],
    );
  }
}
