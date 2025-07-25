import 'package:flutter/material.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/student_bubble.dart';
import 'package:ormee_app/feature/memo/presentation/widgets/teacher_bubble.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';

class Memo extends StatelessWidget {
  const Memo({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrmeeAppBar(
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
        title: "보낸 쪽지",
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 16),
              height: 1,
              color: OrmeeColor.gray[20],
            ),
            Label2Regular12(text: "2024.06.06 (수)", color: OrmeeColor.gray[50]),
            SizedBox(height: 8),
            TeacherBubble(
              text: "틀린 문제 제출하세요.",
              memoState: false,
              // autherImage: '',
            ),
            SizedBox(height: 8),
            StudentBubble(
              context,
              "1, 2, 3, 12, 17, 15, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, ",
            ),
          ],
        ),
      ),
    );
  }
}
