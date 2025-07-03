import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String? profileImageUrl;
  final String defaultImagePath;
  final double opacity;

  const Profile({
    super.key,
    this.profileImageUrl,
    this.defaultImagePath = 'assets/images/default_profile.png',
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
