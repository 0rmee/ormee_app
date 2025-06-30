import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String? profileImageUrl;
  final String defaultImagePath;

  const Profile({
    super.key,
    this.profileImageUrl,
    this.defaultImagePath = 'assets/images/default_profile.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}
