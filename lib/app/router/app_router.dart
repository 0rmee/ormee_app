import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/auth/login/presentation/pages/login.dart';
import 'package:ormee_app/feature/auth/signup/presentation/pages/signup.dart';
import 'package:ormee_app/feature/home/presentation/pages/home.dart';
import 'package:ormee_app/feature/homework/create/presentation/pages/homework_create.dart';
import 'package:ormee_app/feature/notification/bloc/notification_bloc.dart';
import 'package:ormee_app/feature/notification/data/repository.dart';
import 'package:ormee_app/feature/notification/presentation/notification.dart';
import 'package:ormee_app/feature/splash/splash.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/pages/lecture_detail.dart';
import 'package:ormee_app/feature/auth/signup/presentation/pages/branch.dart';
import 'package:ormee_app/feature/lecture/home/bloc/lecture_bloc.dart';
import 'package:ormee_app/feature/lecture/home/presentation/pages/lecture_home.dart';
import 'package:ormee_app/feature/lecture/home/presentation/widgets/qr_scanner.dart';
import 'package:ormee_app/feature/question/create/presentation/pages/question_create.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/lecture_card.dart';
import 'package:ormee_app/shared/widgets/navigationbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';

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
        path: '/profile',
        name: 'profile',
        builder: (context, state) => ProfileScreen(),
      ),
      // GoRoute(
      //   path: '/settings',
      //   name: 'settings',
      //   builder: (context, state) => const SettingsScreen(),
      // ),
      // GoRoute(
      //   path: '/detail/:id',
      //   name: 'detail',
      //   builder: (context, state) {
      //     final id = state.pathParameters['id']!;
      //     return DetailScreen(id: id);
      //   },
      // ),
      GoRoute(
        path: '/lecture/detail/:id',
        name: 'lecture detail',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return LectureDetailScreen(lectureId: id);
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
          // extra에서 BLoC 인스턴스 가져오기
          final bloc = state.extra as LectureHomeBloc?;
          return QRScannerPage(bloc: bloc);
        },
      ),
      ShellRoute(
        builder: (context, state, child) => OrmeeNavigationBar(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
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
            builder: (context, state) => ProfileScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => const ErrorScreen(),
  );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Profile'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              // 탭바 위에 올릴 내용들
              SliverToBoxAdapter(
                child: Row(
                  children: [
                    Expanded(
                      child: OrmeeButton(
                        text: 'text',
                        isTrue: true,
                        trueAction: () {},
                        assetName: 'assets/icons/trash.svg',
                      ),
                    ),
                    Expanded(
                      child: OrmeeButton(
                        text: 'text',
                        isTrue: true,
                        trueAction: () {},
                        assetName: 'assets/icons/trash.svg',
                      ),
                    ),
                  ],
                ),
              ),
              SliverToBoxAdapter(
                child: OrmeeButton(
                  text: 'text',
                  isTrue: true,
                  trueAction: () {},
                  assetName: 'assets/icons/trash.svg',
                ),
              ),
              // 탭바
              SliverAppBar(
                automaticallyImplyLeading: false,
                backgroundColor: Colors.white,
                elevation: 0,
                pinned: true,
                floating: false,
                toolbarHeight: 0,
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: OrmeeTabBar(
                    tabs: [
                      OrmeeTab(text: '공지', notificationCount: 3),
                      OrmeeTab(text: '숙제', notificationCount: null),
                      OrmeeTab(text: '퀴즈', notificationCount: 1),
                    ],
                  ),
                ),
              ),
            ];
          },
          body: TabBarView(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text("내용"),
                    const SizedBox(height: 20),
                    OrmeeLectureCard(
                      title: '오름토익 기본반 RC',
                      teacherNames: '강수이 • 최윤선 T',
                      subText: '재수하지 말자',
                      // dDay: 'D-16',
                    ),
                  ],
                ),
              ),
              const SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
              const SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Settings Screen'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Back Home'),
            ),
          ],
        ),
      ),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final String id;

  const DetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail - $id'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Detail Screen - ID: $id'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Back Home'),
            ),
          ],
        ),
      ),
    );
  }
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
