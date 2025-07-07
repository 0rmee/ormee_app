import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeBottomSheetImage extends StatelessWidget {
  const OrmeeBottomSheetImage({super.key});

  Future<void> _pickImage(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      debugPrint('이미지 선택됨: ${pickedFile.path}');
    } else {
      debugPrint('이미지 선택 취소됨');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 47),
      decoration: BoxDecoration(
        color: OrmeeColor.white,
        border: Border(top: BorderSide(color: OrmeeColor.gray[10]!, width: 1)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () => _pickImage(context),
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.transparent,
              highlightColor: OrmeeColor.gray[20],
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 12,
                ),
                child: Row(
                  children: [
                    SvgPicture.asset('assets/icons/image.svg'),
                    const SizedBox(width: 8),
                    Headline2SemiBold16(
                      text: '사진 첨부',
                      color: OrmeeColor.gray[50],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
