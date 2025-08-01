import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/login/presentation/pages/login.dart';
import 'package:ormee_app/feature/homework/detail/feedback/detail/presentation/pages/feedback_detail.dart';
import 'package:ormee_app/feature/homework/detail/presentation/page/homework_detail.dart';
import 'package:ormee_app/feature/homework/detail/submission/detail/presentation/homework_submission_detail.dart';
import 'package:ormee_app/feature/memo/presentation/pages/memo.dart';
import 'package:ormee_app/feature/mypage/history/presentation/pages/mypage_history.dart';
import 'package:ormee_app/feature/mypage/list/presentation/maypage_list.dart';
import 'package:ormee_app/feature/notice/detail/presentation/page/notice_detail.dart';
import 'package:ormee_app/feature/auth/signup/presentation/pages/signup.dart';
import 'package:ormee_app/feature/home/presentation/pages/home.dart';
import 'package:ormee_app/feature/homework/create/presentation/pages/homework_create.dart';
import 'package:ormee_app/feature/notification/bloc/notification_bloc.dart';
import 'package:ormee_app/feature/notification/data/repository.dart';
import 'package:ormee_app/feature/notification/presentation/notification.dart';
import 'package:ormee_app/feature/quiz/result/presentation/quiz_result.dart';
import 'package:ormee_app/feature/quiz/detail/presentation/quiz_detail.dart';
import 'package:ormee_app/feature/question/detail/answer/presentation/answer_detail.dart';
import 'package:ormee_app/feature/question/detail/presentation/question_detail.dart';
import 'package:ormee_app/feature/question/list/presentation/question_list.dart';
import 'package:ormee_app/feature/search/presentation/pages/notice_search.dart';
import 'package:ormee_app/feature/search/presentation/pages/notification_search.dart';
import 'package:ormee_app/feature/splash/splash.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/pages/lecture_detail.dart';
import 'package:ormee_app/feature/auth/signup/presentation/pages/branch.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/presentation/pages/lecture_home.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/qr_scanner.dart';
import 'package:ormee_app/feature/question/create/presentation/pages/question_create.dart';
import 'package:ormee_app/shared/widgets/full_image_viewer.dart';
import 'package:ormee_app/shared/widgets/navigationbar.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const Login(),
      ),
      GoRoute(
        path: '/branch',
        name: 'branch',
        builder: (context, state) => const Branch(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => Signup(),
      ),
      GoRoute(
        path: '/lecture/detail/:id',
        name: 'lecture detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LectureDetailScreen(lectureId: id);
        },
      ),
      GoRoute(
        path: '/lecture/detail/:id/memo',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return Memo(lectureId: id);
        },
      ),
      GoRoute(
        path: '/lecture/detail/:id/question/create',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return QuestionCreate(lectureId: id);
        },
      ),
      GoRoute(
        path: '/lecture/detail/homework/:id/create',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final title = state.extra as String;
          return HomeworkCreate(homeworkId: id, title: title);
        },
      ),
      GoRoute(
        path: '/qr-scanner',
        builder: (context, state) {
          final bloc = state.extra as LectureHomeBloc?;
          return QRScannerPage(bloc: bloc);
        },
      ),
      GoRoute(
        path: '/notice/detail/:id',
        name: 'notice detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return NoticeDetailScreen(noticeId: id);
        },
      ),
      GoRoute(
        path: '/search/notice/:lectureId',
        builder: (context, state) {
          final lectureId = int.parse(state.pathParameters['lectureId']!);
          return NoticeSearch(lectureId: lectureId);
        },
      ),
      GoRoute(
        path: '/homework/detail/:id',
        name: 'homework detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return HomeworkDetailScreen(homeworkId: id);
        },
      ),
      GoRoute(
        path: '/homework/submission/detail/:id',
        name: 'homework submission detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final title = state.extra as String;
          return HomeworkSubmissionDetailScreen(
            homeworkId: id,
            homeworkTitle: title,
          );
        },
      ),
      GoRoute(
        path: '/homework/feedback/detail/:id',
        name: 'feedback detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return FeedbackDetailScreen(submissionId: id);
        },
      ),
      GoRoute(
        path: '/quiz/result/:id',
        name: 'quiz_result',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          final title = state.uri.queryParameters['title'] ?? '퀴즈 결과';
          return QuizResultScreen(quizId: id, title: title);
        },
      ),
      GoRoute(
        path: '/quiz/detail/:id',
        name: 'quiz_detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return QuizDetailScreen(quizId: id);
        },
      ),
      GoRoute(
        path: '/question/list/:id',
        name: 'question list',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return QuestionListScreen(lectureId: id);
        },
      ),
      GoRoute(
        path: '/question/detail/:id',
        name: 'question detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return QuestionDetailScreen(questionId: id);
        },
      ),
      GoRoute(
        path: '/answer/detail/:id',
        name: 'answer detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return AnswerDetailScreen(questionId: id);
        },
      ),
      GoRoute(
        path: '/image/viewer',
        name: 'full image viewer',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final imageUrls = extra['imageUrls'] as List<String>;
          final initialIndex = extra['initialIndex'] as int;

          return ImageFullScreenViewer(
            imageUrls: imageUrls,
            initialIndex: initialIndex,
          );
        },
      ),
      GoRoute(
        path: '/notification/search',
        builder: (context, state) {
          return NotificationSearch();
        },
      ),
      GoRoute(
        path: '/mypage/history',
        builder: (context, state) {
          return MypageHistory();
        },
      ),
      ShellRoute(
        builder: (context, state, child) => OrmeeNavigationBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreenWrapper(),
          ),
          GoRoute(
            path: '/lecture',
            name: 'lecture home',
            builder: (context, state) => LectureHome(),
          ),
          GoRoute(
            path: '/notification',
            name: "notification",
            builder: (context, state) {
              return BlocProvider(
                create: (_) =>
                    NotificationBloc(repository: NotificationRepository()),
                child: const NotificationScreen(),
              );
            },
          ),
          GoRoute(
            path: '/mypage',
            name: 'mypage',
            builder: (context, state) => MyPageScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Error'), backgroundColor: Colors.red),
      body: const Center(child: Text('Page not found!')),
    );
  }
}
