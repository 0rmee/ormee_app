import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_event.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_state.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_repository.dart';
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
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupDependencies() {
  // RemoteDataSource 등록
  getIt.registerLazySingleton<NoticeRemoteDataSource>(
    () => NoticeRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<QuizRemoteDataSource>(
    () => QuizRemoteDataSource(http.Client()),
  );
  getIt.registerLazySingleton<HomeworkRemoteDataSource>(
    () => HomeworkRemoteDataSource(http.Client()),
  );

  // Repository 등록
  getIt.registerLazySingleton<NoticeRepository>(
    () => NoticeRepository(getIt()),
  );
  getIt.registerLazySingleton<QuizRepository>(() => QuizRepository(getIt()));
  getIt.registerLazySingleton<HomeworkRepository>(
    () => HomeworkRepository(getIt()),
  );

  // Bloc 등록
  getIt.registerFactory<NoticeBloc>(() => NoticeBloc(getIt()));
  getIt.registerFactory<QuizBloc>(() => QuizBloc(getIt()));
  getIt.registerFactory<HomeworkBloc>(() => HomeworkBloc(getIt()));
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
