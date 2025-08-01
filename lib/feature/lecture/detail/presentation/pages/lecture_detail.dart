import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:ormee_app/core/network/memo_sse.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
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

String dayToKorean(String day) {
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

class LectureDetailScreen extends StatefulWidget {
  final int lectureId;

  LectureDetailScreen({super.key, required this.lectureId});

  @override
  State<LectureDetailScreen> createState() => _LectureDetailScreenState();
}

class _LectureDetailScreenState extends State<LectureDetailScreen>
    with WidgetsBindingObserver {
  late MemoSSEManager memoSSEManager;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeSSE();
  }

  Future<void> _initializeSSE() async {
    try {
      // SSE 매니저 생성 (이 시점에서 late 필드 초기화)
      memoSSEManager = MemoSSEManager(
        lectureId: widget.lectureId.toString(),
        router: GoRouter.of(context),
      );

      // AuthStorage에 토큰 업데이트 콜백 등록
      AuthStorage.registerTokenUpdateCallback(memoSSEManager.onTokenUpdated);

      // SSE 매니저 초기화 및 시작
      await memoSSEManager.initialize();
      await memoSSEManager.start();

      // 메모 상태 변화 리스너 등록
      memoSSEManager.memoStateNotifier.addListener(_onMemoStateChanged);

      setState(() {
        _isInitialized = true;
      });

      print('✅ [LECTURE] SSE Manager initialized successfully');
    } catch (e) {
      print('❌ [LECTURE] Failed to initialize SSE Manager: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('연결 실패: $e')));
      }
    }
  }

  void _onMemoStateChanged() {
    if (mounted && _isInitialized) {
      print(
        '📝 [LECTURE] Memo state changed: ${memoSSEManager.currentMemoState}',
      );
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    if (_isInitialized) {
      AuthStorage.unregisterTokenUpdateCallback(memoSSEManager.onTokenUpdated);
      memoSSEManager.memoStateNotifier.removeListener(_onMemoStateChanged);
      memoSSEManager.dispose();
    }

    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    print("🔄 App lifecycle changed: $state");

    switch (state) {
      case AppLifecycleState.resumed:
        print("▶️ App resumed - resuming SSE");
        memoSSEManager.resume();
        break;
      case AppLifecycleState.inactive:
        print("⏸️ App inactive - pausing SSE");
        memoSSEManager.pause();
        break;
      case AppLifecycleState.paused:
        print("⏸️ App paused - pausing SSE");
        memoSSEManager.pause();
        break;
      case AppLifecycleState.detached:
        print("🛑 App detached - disposing SSE");
        memoSSEManager.dispose();
        break;
      case AppLifecycleState.hidden:
        print("👻 App hidden - pausing SSE");
        memoSSEManager.pause();
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              getIt<NoticeBloc>()..add(FetchNotices(widget.lectureId)),
        ),
        BlocProvider(
          create: (_) => getIt<QuizBloc>()..add(FetchQuizzes(widget.lectureId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<HomeworkBloc>()..add(FetchHomeworks(widget.lectureId)),
        ),
        BlocProvider(
          create: (_) =>
              getIt<LectureBloc>()..add(FetchLectureDetail(widget.lectureId)),
        ),
      ],
      child: DefaultTabController(
        length: 3,
        child: ValueListenableBuilder(
          valueListenable: memoSSEManager.memoStateNotifier,
          builder: (context, memoState, _) {
            return ValueListenableBuilder(
              valueListenable: memoSSEManager.memoIdNotifier, // 추가
              builder: (context, memoId, _) {
                return BlocBuilder<LectureBloc, LectureState>(
                  builder: (context, state) {
                    if (state is LectureLoading) {
                      return const Scaffold(
                        body: Center(child: CircularProgressIndicator()),
                      );
                    } else if (state is LectureLoaded) {
                      final data = state.lecture;

                      return Scaffold(
                        appBar: OrmeeAppBar(
                          isLecture: true,
                          title: data.title,
                          isImage: false,
                          isDetail: false,
                          isPosting: false,
                          memoState: memoState,
                          lectureId: data.id,
                          memoId: int.tryParse(memoId ?? ''),
                        ),
                        body: Column(
                          children: [
                            OrmeeTeacherCard(
                              lectureId: data.id,
                              teacherNames: [
                                data.name,
                                ...data.coTeachers.map((e) => e.name),
                              ],
                              teacherImages: [
                                if (data.profileImage != null)
                                  data.profileImage!,
                                ...data.coTeachers
                                    .map((e) => e.image)
                                    .whereType<String>(),
                              ],
                              startTime: data.formattedStartTime,
                              endTime: data.formattedEndTime,
                              startPeriod: data.formattedStartDate,
                              endPeriod: data.formattedDueDate,
                              day: data.lectureDays
                                  .map((e) => dayToKorean(e))
                                  .toList(),
                            ),
                            Container(
                              height: 8,
                              color: const Color(0xFFFBFBFB),
                            ),
                            Container(
                              color: Colors.white,
                              child: BlocBuilder<NoticeBloc, NoticeState>(
                                builder: (context, noticeState) {
                                  return BlocBuilder<QuizBloc, QuizState>(
                                    builder: (context, quizState) {
                                      return BlocBuilder<
                                        HomeworkBloc,
                                        HomeworkState
                                      >(
                                        builder: (context, homeworkState) {
                                          final noticeCount =
                                              noticeState is NoticeLoaded
                                              ? noticeState.notices.length
                                              : null;
                                          final quizCount =
                                              quizState is QuizLoaded
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
                                                notificationCount:
                                                    homeworkCount,
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
                                  Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      SearchButton(),
                                      Expanded(child: NoticeTab()),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      Expanded(child: QuizTab()),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      const SizedBox(height: 12),
                                      Expanded(child: HomeworkTab()),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (state is LectureError) {
                      return Scaffold(
                        appBar: OrmeeAppBar(
                          isLecture: true,
                          title: '강의 상세',
                          isImage: false,
                          isDetail: false,
                          isPosting: false,
                          memoState: true, // TODO: 위와 동일하게 진행
                          memoId: 1, // TODO: 위와 동일하게 진행
                        ),
                        body: Center(child: Text('에러: ${state.message}')),
                      );
                    } else {
                      return const SizedBox();
                    }
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
