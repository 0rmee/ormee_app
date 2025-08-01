import 'package:flutter/material.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';

class MypageHistory extends StatelessWidget {
  const MypageHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: OrmeeAppBar(
        title: '수강내역',
        isLecture: false,
        isImage: false,
        isDetail: false,
        isPosting: false,
      ),
      body: Container(),
    );
  }
}
