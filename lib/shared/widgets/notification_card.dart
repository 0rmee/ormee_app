import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/profile.dart';

class NotificationCard extends StatelessWidget {
  final String? profile;
  final String headline;
  final String title;
  final String body;
  final String time;
  final bool read;

  const NotificationCard({
    super.key,
    this.profile,
    required this.headline,
    required this.title,
    required this.body,
    required this.time,
    this.read = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10),
      width: double.maxFinite,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Profile(profileImageUrl: profile, opacity: read ? 0.5 : 1),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Headline2Bold16(
                      text: headline,
                      color: OrmeeColor.gray[read ? 50 : 800],
                    ),
                    Caption2Semibold10(text: time, color: OrmeeColor.gray[40]),
                  ],
                ),
                SizedBox(height: 6),
                Label1Semibold14(
                  text: title,
                  color: OrmeeColor.gray[read ? 50 : 75],
                ),
                Body2RegularNormal14(
                  text: body,
                  color: OrmeeColor.gray[read ? 50 : 75],
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
