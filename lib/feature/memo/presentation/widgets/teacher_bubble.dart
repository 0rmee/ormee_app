import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class TeacherBubble extends StatelessWidget {
  final String text;
  final bool memoState;
  final String? autherImage;

  const TeacherBubble({
    Key? key,
    required this.text,
    required this.memoState,
    this.autherImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!memoState) ...[
          Wrap(
            children: [
              if (autherImage != null && autherImage!.isNotEmpty)
                Profile(profileImageUrl: autherImage, size1: 18)
              else
                Profile(size1: 18),
            ],
          ),
          SizedBox(width: 4),
        ],
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset('assets/icons/polygon.svg'),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: memoState
                    ? MediaQuery.of(context).size.width * 0.6
                    : MediaQuery.of(context).size.width * 0.7,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 10,
                ),
                decoration: BoxDecoration(
                  color: OrmeeColor.gray[20],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Body2RegularNormal14(text: text),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
