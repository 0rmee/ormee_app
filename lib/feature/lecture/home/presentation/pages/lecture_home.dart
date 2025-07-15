import 'package:flutter/material.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/appbar.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';

class LectureHome extends StatelessWidget {
  const LectureHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: LectureHomeAppBar(count: 100),
      body: LectureHomeEmpty(context),
    );
  }
}
