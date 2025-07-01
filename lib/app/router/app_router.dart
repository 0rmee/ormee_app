import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/box.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/dialog.dart';
import 'package:ormee_app/shared/widgets/navigationbar.dart';
import 'package:ormee_app/shared/widgets/tab.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
      // GoRoute(
      //   path: '/home',
      //   name: 'home',
      //   builder: (context, state) => const HomeScreen(),
      // ),
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
            name: 'lecture',
            builder: (context, state) => ProfileScreen(),
          ),
          GoRoute(
            path: '/notification',
            name: 'notification',
            builder: (context, state) => const SettingsScreen(),
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

// 예시 화면들
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ormee Home'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Welcome to Ormee App!'),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => context.go('/profile'),
              child: const Text('Go to Profile'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/settings'),
              child: const Text('Go to Settings'),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () => context.go('/detail/123'),
              child: const Text('Go to Detail (ID: 123)'),
            ),
          ],
        ),
      ),
    );
  }
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
              SliverToBoxAdapter(child: Container()),
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
          body: const TabBarView(
            children: [
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
              SingleChildScrollView(
                padding: EdgeInsets.all(16.0),
                child: Column(children: [Text("내용")]),
              ),
              SingleChildScrollView(
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
