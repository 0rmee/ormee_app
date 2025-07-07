import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/teacher_card.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/notice_card.dart';
import 'package:ormee_app/shared/widgets/tab.dart';

class LectureDetailScreen extends StatelessWidget {
  const LectureDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: OrmeeAppBar(
          isLecture: true,
          title: "오름토익 기본반",
          isImage: false,
          isDetail: false,
          isPosting: false,
        ),
        body: Column(
          children: [
            OrmeeTeacherCard(
              teacherNames: ['강수이'],
              startTime: '15:30',
              endTime: '16:30',
              startPeriod: '2025.06.01',
              endPeriod: '2025.07.30',
              day: ['월', '수'],
            ),
            Container(
              color: Colors.white,
              child: OrmeeTabBar(
                tabs: [
                  OrmeeTab(text: '공지', notificationCount: null),
                  OrmeeTab(text: '퀴즈', notificationCount: null),
                  OrmeeTab(text: '숙제', notificationCount: null),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // 공지 탭
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          vertical: 12,
                          horizontal: 20,
                        ),
                        width: double.infinity,
                        color: Colors.white,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              'assets/icons/search_20.svg',
                              color: OrmeeColor.gray[50],
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          itemBuilder: (BuildContext context, index) {
                            return NoticeCard(
                              read: false,
                              date: '2024.06.06 (수)',
                              notice: '출석체크 꼭 하세요',
                              teacher: '강수이',
                            );
                          },
                          separatorBuilder: (context, index) =>
                              Divider(color: OrmeeColor.gray[20]),
                          itemCount: 15,
                        ),
                      ),
                    ],
                  ),
                  // 퀴즈 탭
                  const SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(children: [Text("내용")]),
                  ),
                  // 숙제 탭
                  const SingleChildScrollView(
                    padding: EdgeInsets.all(16.0),
                    child: Column(children: [Text("내용")]),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
