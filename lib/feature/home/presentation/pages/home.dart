import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ormee_app/feature/home/presentation/widgets/banner.dart';
import 'package:ormee_app/feature/home/presentation/widgets/homework_list.dart';
import 'package:ormee_app/feature/home/presentation/widgets/lecture_list.dart';
import 'package:ormee_app/feature/home/presentation/widgets/quiz_list.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/pages/lecture_detail.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/lecture_home_empty.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OrmeeColor.gray[10],
      appBar: AppBar(
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 4),
          alignment: Alignment.centerLeft,
          child: SvgPicture.asset('assets/icons/ormee.svg'),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: AutoBannerSlider(
              imageUrls: [
                'https://ormee-bucket.s3.ap-northeast-2.amazonaws.com/2025-05-22%E1%84%91%E1%85%A6%E1%86%BC%E1%84%80%E1%85%B1%E1%86%AB.png',
                'https://ormee-bucket.s3.ap-northeast-2.amazonaws.com/2025-05-22%E1%84%91%E1%85%A6%E1%86%BC%E1%84%80%E1%85%B1%E1%86%AB.png',
                'https://ormee-bucket.s3.ap-northeast-2.amazonaws.com/2025-05-22%E1%84%91%E1%85%A6%E1%86%BC%E1%84%80%E1%85%B1%E1%86%AB.png',
              ],
            ),
          ),
          // 강의 없는 경우
          // LectureHomeEmpty(bloc: context.read<LectureHomeBloc>()),
          SizedBox(height: MediaQuery.of(context).size.height * 0.02),

          // 수업
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Headline2SemiBold16(text: '수업'),
          ),
          SizedBox(height: 6),
          LectureCardSlider(
            lectures: [
              LectureCard(
                title: '오름토익 기본반',
                days: ["MON", "WED"].map((e) => dayToKorean(e)).toList(),
                startTime: "15:30:00",
                endTime: "17:00:00",
                startDate: "2025-06-03T00:00:00",
                dueDate: "2026-08-29T23:59:59",
              ),
              LectureCard(
                title: 'title',
                days: ["MON", "WED"].map((e) => dayToKorean(e)).toList(),
                startTime: "15:30:00",
                endTime: "17:00:00",
                startDate: "2025-06-03T00:00:00",
                dueDate: "2026-08-29T23:59:59",
              ),
            ],
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          // 퀴즈
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Headline2SemiBold16(text: '퀴즈 '),
                Headline2SemiBold16(text: '3', color: OrmeeColor.purple[50]),
              ],
            ),
          ),
          SizedBox(height: 6),
          QuizCardSlider(
            quizzes: [
              QuizCard(
                lectureTitle: '오름토익 기본반 RC',
                quizTitle: "객체지향 프로그래밍 퀴즈5",
                quizDueTime: "2025.07.10 23:59",
              ),
              QuizCard(
                lectureTitle: '오름토익 기본반 RC',
                quizTitle: "객체지향 프로그래밍 퀴즈5",
                quizDueTime: "2025.07.10 23:59",
              ),
              QuizCard(
                lectureTitle: '오름토익 기본반 RC',
                quizTitle: "객체지향 프로그래밍 퀴즈5",
                quizDueTime: "2025.07.10 23:59",
              ),
            ],
          ),
          // 퀴즈 없는 경우
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.12,
          //   child: Center(
          //     child: Label1Semibold14(
          //       text: '응시 가능한 퀴즈가 없어요',
          //       color: OrmeeColor.gray[40],
          //     ),
          //   ),
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),

          // 숙제
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Headline2SemiBold16(text: '숙제 '),
                Headline2SemiBold16(text: '3', color: OrmeeColor.purple[50]),
              ],
            ),
          ),
          SizedBox(height: 6),
          HomeworkCardSlider(
            homeworks: [
              HomeworkCard(
                lectureTitle: '오름토익 기본반 RC',
                homeworkTitle: "과제",
                homeworkDueTime: "2025.07.10 23:59",
              ),
            ],
          ),
          // 숙제 없는 경우
          // SizedBox(
          //   height: MediaQuery.of(context).size.height * 0.12,
          //   child: Center(
          //     child: Label1Semibold14(
          //       text: '제출 가능한 숙제가 없어요',
          //       color: OrmeeColor.gray[40],
          //     ),
          //   ),
          // ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.03),
        ],
      ),
    );
  }
}
