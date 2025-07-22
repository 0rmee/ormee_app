import 'package:flutter/material.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';

class Profile extends StatelessWidget {
  final String? profileImageUrl;
  final String defaultImagePath;
  final double opacity;
  final double? size1;

  const Profile({
    super.key,
    this.profileImageUrl,
    this.defaultImagePath = 'assets/images/profile48.png',
    this.opacity = 1.0,
    this.size1 = 48.0,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: Container(
        width: size1,
        height: size1,
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
  final double? size1;
  final double? size2;
  final double? border;

  const MultiProfile({
    super.key,
    this.profileImageUrl,
    this.otherProfileImageUrl,
    this.defaultImagePath = 'assets/images/profile48.png',
    this.size1 = 32.0,
    this.size2 = 32.0,
    this.border,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size1,
      height: size1,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // 아래에 깔리는 원형 이미지
          Container(
            width: size2,
            height: size2,
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
              width: size2,
              height: size2,
              decoration: BoxDecoration(
                border: Border.all(
                  width: border ?? 1.0,
                  color: OrmeeColor.white,
                ),
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
