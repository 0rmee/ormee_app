import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class OrmeeBottomSheetImage extends StatelessWidget {
  final bool? isQuestion;
  final bool? isSecret;
  final VoidCallback? onImagePick; // 콜백 함수 추가
  final VoidCallback? onSecretToggle;

  const OrmeeBottomSheetImage({
    super.key,
    this.isQuestion,
    this.isSecret,
    this.onImagePick,
    this.onSecretToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 28),
      decoration: BoxDecoration(
        color: OrmeeColor.white,
        border: Border(top: BorderSide(color: OrmeeColor.gray[10]!, width: 1)),
      ),
      child: Row(
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: onImagePick, // 콜백 함수 호출
              borderRadius: BorderRadius.circular(12),
              splashColor: Colors.transparent,
              highlightColor: OrmeeColor.gray[20],
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
          const Spacer(),
          if (isQuestion == true) ...[
            Headline2SemiBold16(text: '비밀글', color: OrmeeColor.gray[50]),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: onSecretToggle,
              child: SvgPicture.asset(
                'assets/icons/box=$isSecret.svg',
                width: 18,
                height: 18,
                fit: BoxFit.scaleDown,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
