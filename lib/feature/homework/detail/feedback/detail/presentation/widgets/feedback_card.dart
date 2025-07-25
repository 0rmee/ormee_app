import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/data/model.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/html_text.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class FeedbackCard extends StatelessWidget {
  final FeedbackDetailModel feedback;

  const FeedbackCard({super.key, required this.feedback});

  @override
  Widget build(BuildContext context) {
    final bool hasContent = feedback.content?.trim().isNotEmpty ?? false;
    final String stampAsset = getStampAssetPath(feedback.stamp);
    final bool hasStamp = stampAsset.isNotEmpty;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Profile(profileImageUrl: feedback.author.image, size1: 18),
                SizedBox(width: 8),
                Label1Semibold14(
                  text: feedback.author.name,
                  color: OrmeeColor.gray[90],
                ),
              ],
            ),
            Caption1Regular11(
              text: DateFormat('yy.MM.dd').format(feedback.createdAt),
              color: OrmeeColor.gray[50],
            ),
          ],
        ),
        SizedBox(height: 16),
        if (hasContent || hasStamp)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasContent)
                HtmlTextWidget(text: feedback.content),
              if (hasContent && hasStamp)
                const SizedBox(height: 16),
              if (hasStamp)
                Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: Center(
                      child: SvgPicture.asset(
                        stampAsset,
                        width: 140, // or auto
                        height: 140,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
            ],
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  String getStampAssetPath(String stamp) {
    switch (stamp.toUpperCase()) {
      case 'EXCELLENT':
        return 'assets/images/stamps/excellent.svg';
      case 'FIGHTING':
        return 'assets/images/stamps/fighting.svg';
      case 'GOOD':
        return 'assets/images/stamps/good.svg';
      case 'IMPROVE':
        return 'assets/images/stamps/improve.svg';
      case 'OK':
        return 'assets/images/stamps/ok.svg';
      default:
        return '';
    }
  }
}
