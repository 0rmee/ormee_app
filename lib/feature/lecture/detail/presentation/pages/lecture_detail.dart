import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/homework/bloc/homework_event.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/homework/data/homework_repository.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/notice/bloc/notice_event.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/notice/data/notice_repository.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/homework_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/notice_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/quiz_tab.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/widgets/teacher_card.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_bloc.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/bloc/quiz_event.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_remote_datasource.dart';
import 'package:ormee_app/feature/lecture/detail/quiz/data/quiz_repository.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/widgets/appbar.dart';
import 'package:ormee_app/shared/widgets/box.dart';
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
                        Expanded(child: NoticeTab()),
                        SizedBox(height: 80),
                      ],
                    ),
                    // 퀴즈 탭
                    Column(
                      children: [
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              OrmeeBox(text: '전체', isCheck: true),
                              SizedBox(width: 4),
                              OrmeeBox(text: '미제출', isCheck: false),
                              SizedBox(width: 4),
                              OrmeeBox(text: '제출완료', isCheck: false),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/icons/search_20.svg',
                                color: OrmeeColor.gray[50],
                              ),
                            ],
                          ),
                        ),
                        Expanded(child: QuizTab()),
                        SizedBox(height: 80),
                      ],
                    ),
                    // 숙제 탭
                    Column(
                      children: [
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 8,
                            horizontal: 20,
                          ),
                          width: double.infinity,
                          color: Colors.white,
                          child: Row(
                            children: [
                              OrmeeBox(text: '전체', isCheck: true),
                              SizedBox(width: 4),
                              OrmeeBox(text: '미제출', isCheck: false),
                              SizedBox(width: 4),
                              OrmeeBox(text: '제출완료', isCheck: false),
                              Spacer(),
                              SvgPicture.asset(
                                'assets/icons/search_20.svg',
                                color: OrmeeColor.gray[50],
                              ),
                            ],
                          ),
                        ),
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
