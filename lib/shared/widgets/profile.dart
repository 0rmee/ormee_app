import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class Profile extends StatelessWidget {
  final String? profileImageUrl;
  final String defaultImagePath;
  final double opacity;

  const Profile({
    super.key,
    this.profileImageUrl,
    this.defaultImagePath = 'assets/images/profile48.png',
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          image: DecorationImage(
            image: profileImageUrl != null
                ? NetworkImage(profileImageUrl!) as ImageProvider
                : AssetImage(defaultImagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

class MultiProfile extends StatelessWidget {
  final String? profileImageUrl;
  final String? otherProfileImageUrl;
  final String defaultImagePath;

  const MultiProfile({
    super.key,
    this.profileImageUrl,
    this.otherProfileImageUrl,
    this.defaultImagePath = 'assets/images/profile48.png',
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 아래에 깔리는 원형 이미지
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!) as ImageProvider
                    : AssetImage(defaultImagePath),
                fit: BoxFit.cover,
              ),
            ),
          ),

          // 위에 올라가는 원형 이미지
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                border: Border.all(width: 1.0, color: OrmeeColor.white),
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: otherProfileImageUrl != null
                      ? NetworkImage(otherProfileImageUrl!) as ImageProvider
                      : AssetImage(defaultImagePath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
