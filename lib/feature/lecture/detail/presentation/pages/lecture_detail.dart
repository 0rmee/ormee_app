import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_event.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_state.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_repository.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/bloc/lecture_event.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/bloc/lecture_state.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/lecture/data/lecture_repository.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_event.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_state.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_repository.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/homework_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/notice_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/quiz_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/search_button.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/teacher_card.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_state.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // lecture/detail/notice
  getIt.registerLazySingleton<NoticeRemoteDataSource>(
    () => NoticeRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<NoticeRepository>(
    () => NoticeRepository(getIt()),
  );
  getIt.registerFactory<NoticeBloc>(() => NoticeBloc(getIt()));

  // lecture/detail/quiz
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<QuizRepository>(() => QuizRepository(getIt()));
  getIt.registerFactory<QuizBloc>(() => QuizBloc(getIt()));

  // lecture/detail/homework
  getIt.registerLazySingleton<HomeworkRemoteDataSource>(
    () => HomeworkRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<HomeworkRepository>(
    () => HomeworkRepository(getIt()),
  );
  getIt.registerFactory<HomeworkBloc>(() => HomeworkBloc(getIt()));

  // lecture/detail/lecture
  getIt.registerLazySingleton<LectureRemoteDataSource>(
    () => LectureRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<LectureRepository>(
    () => LectureRepository(getIt()),
  );
  getIt.registerFactory<LectureBloc>(() => LectureBloc(getIt()));
}

String _dayToKorean(String day) {
  switch (day) {
    case 'MON':
      return '월';
    case 'TUE':
      return '화';
    case 'WED':
      return '수';
    case 'THU':
      return '목';
    case 'FRI':
      return '금';
    case 'SAT':
      return '토';
    case 'SUN':
      return '일';
    default:
      return '';
  }
}

class LectureDetailScreen extends StatelessWidget {
  final int lectureId;
  LectureDetailScreen({super.key, required this.lectureId});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => getIt<NoticeBloc>()..add(FetchNotices(lectureId)),
        ),
        BlocProvider(
          create: (_) => getIt<QuizBloc>()..add(FetchQuizzes(lectureId)),
        ),
        BlocProvider(
          create: (_) => getIt<HomeworkBloc>()..add(FetchHomeworks(lectureId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<LectureBloc>()..add(FetchLectureDetail(lectureId)),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: OrmeeAppBar(
            isLecture: true,
            title: "오름토익 기본반",
            isImage: false,
            isDetail: false,
            isPosting: false,
            memoState: false,
          ),
          body: Column(
            children: [
              // OrmeeTeacherCard(
              //   teacherNames: ['강수이'],
              //   startTime: '15:30',
              //   endTime: '16:30',
              //   startPeriod: '2025.06.01',
              //   endPeriod: '2025.07.30',
              //   day: ['월', '수'],
              // ),
              BlocBuilder<LectureBloc, LectureState>(
                builder: (context, state) {
                  if (state is LectureLoading) {
                    return CircularProgressIndicator();
                  } else if (state is LectureLoaded) {
                    final data = state.lecture;
                    return OrmeeTeacherCard(
                      teacherNames: [
                        data.name,
                        ...data.coTeachers.map((e) => e.name),
                      ],
                      teacherImages: [
                        if (data.profileImage != null) data.profileImage!,
                        ...data.coTeachers
                            .map((e) => e.image)
                            .whereType<String>(),
                      ],
                      startTime: data.formattedStartTime,
                      endTime: data.formattedEndTime,
                      startPeriod: data.startDate ?? 'YYYY.MM.DD',
                      endPeriod: data.dueDate ?? 'YYYY.MM.DD',
                      day: data.lectureDays
                          .map((e) => _dayToKorean(e))
                          .toList(),
                    );
                  } else if (state is LectureError) {
                    return Text('에러: ${state.message}');
                  } else {
                    return SizedBox();
                  }
                },
              ),
              Container(height: 8, color: const Color(0xFFFBFBFB)),
              Container(
                color: Colors.white,
                child: BlocBuilder<NoticeBloc, NoticeState>(
                  builder: (context, noticeState) {
                    return BlocBuilder<QuizBloc, QuizState>(
                      builder: (context, quizState) {
                        return BlocBuilder<HomeworkBloc, HomeworkState>(
                          builder: (context, homeworkState) {
                            final noticeCount = noticeState is NoticeLoaded
                                ? noticeState.notices.length
                                : null;
                            final quizCount = quizState is QuizLoaded
                                ? quizState.quizzes.length
                                : null;
                            final homeworkCount =
                                homeworkState is HomeworkLoaded
                                ? homeworkState.homeworks.length
                                : null;

                            return OrmeeTabBar(
                              tabs: [
                                OrmeeTab(
                                  text: '공지',
                                  notificationCount: noticeCount,
                                ),
                                OrmeeTab(
                                  text: '퀴즈',
                                  notificationCount: quizCount,
                                ),
                                OrmeeTab(
                                  text: '숙제',
                                  notificationCount: homeworkCount,
                                ),
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                ),
              ),
              Expanded(
                child: TabBarView(
                  children: [
                    // 공지 탭
                    Column(
                      children: [
                        SizedBox(height: 12),
                        SearchButton(),
                        Expanded(child: NoticeTab()),
                        SizedBox(height: 80),
                      ],
                    ),
                    // 퀴즈 탭
                    Column(
                      children: [
                        SizedBox(height: 12),
                        Expanded(child: QuizTab()),
                        SizedBox(height: 80),
                      ],
                    ),
                    // 숙제 탭
                    Column(
                      children: [
                        SizedBox(height: 12),
                        Expanded(child: HomeworkTab()),
                        SizedBox(height: 80),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
