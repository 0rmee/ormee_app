import 'package:flutter/material.dart' hide SearchBar;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:ormee_app/feature/search/search_bloc.dart';
import 'package:ormee_app/feature/search/search_event.dart';
import 'package:ormee_app/shared/theme/app_colors.dart';
import 'package:ormee_app/shared/theme/app_fonts.dart';
import 'package:ormee_app/shared/widgets/assignment_card.dart';
import 'package:ormee_app/shared/widgets/bottomsheet.dart';
import 'package:ormee_app/shared/widgets/box.dart';
import 'package:ormee_app/shared/widgets/button.dart';
import 'package:ormee_app/shared/widgets/day_badge';
import 'package:ormee_app/shared/widgets/dialog.dart';
import 'package:ormee_app/shared/widgets/downloader.dart';
import 'package:ormee_app/shared/widgets/fab.dart';
import 'package:ormee_app/shared/widgets/lecture_card.dart';
import 'package:ormee_app/shared/widgets/navigationbar.dart';
import 'package:ormee_app/shared/widgets/notice_card.dart';
import 'package:ormee_app/shared/widgets/notification_card.dart';
import 'package:ormee_app/shared/widgets/profile.dart';
import 'package:ormee_app/shared/widgets/state_badge.dart';
import 'package:ormee_app/shared/widgets/tab.dart';
import 'package:ormee_app/shared/widgets/search_bar.dart';
import 'package:ormee_app/shared/widgets/textfield.dart';

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

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => SearchBloc(),
//       child: const _HomeScreenView(),
//     );
//   }
// }

// // 예시 화면들
// class _HomeScreenView extends StatefulWidget  {
//   const _HomeScreenView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final TextEditingController _controller = TextEditingController();
//     final FocusNode _focusNode = FocusNode();
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Ormee Home'),
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Text('Welcome to Ormee App!'),
//             const SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => context.go('/profile'),
//               child: const Text('Go to Profile'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => context.go('/settings'),
//               child: const Text('Go to Settings'),
//             ),
//             const SizedBox(height: 10),
//             ElevatedButton(
//               onPressed: () => context.go('/detail/123'),
//               child: const Text('Go to Detail (ID: 123)'),
//             ),
//             DayBadge(text: '월'),

//             SearchBar(
//               controller: _controller,
//               focusNode: _focusNode,
//               onChanged: (text) {
//                 context.read<SearchBloc>().add(SearchTextChanged(text));
//               },
//               onSearch: () {
//                 context.read<SearchBloc>().add(
//                   SearchSubmitted(_controller.text),
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();
  bool isTextFieldNotEmpty2 = false; // 일반 bool 변수
  bool isPwNotEmpty = false;

  final TextEditingController _controller_1 = TextEditingController();
  bool isTextFieldNotEmpty1 = false; // 일반 bool 변수
  bool isIdNotEmpty = false;
  final FocusNode _idFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  OrmeeTextField(
                    hintText: "이름을 입력하세요.",
                    controller: _controller_1,
                    focusNode: _idFocusNode,
                    textInputAction: TextInputAction.next,
                    isTextNotEmpty: isTextFieldNotEmpty1,
                    onTextChanged: (text) {
                      // BLoC 이벤트 발생 또는 setState 호출
                      setState(() {
                        isTextFieldNotEmpty1 = text.isNotEmpty;
                      });
                    },
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                  OrmeeTextField(
                    hintText: "비번을 입력하세요.",
                    controller: _controller,
                    focusNode: _focusNode,
                    textInputAction: TextInputAction.next,
                    isTextNotEmpty: isTextFieldNotEmpty2,
                    isPassword: true,
                    onTextChanged: (text) {
                      // BLoC 이벤트 발생 또는 setState 호출
                      setState(() {
                        isTextFieldNotEmpty2 = text.isNotEmpty;
                      });
                    },
                    onFieldSubmitted: (term) {
                      FocusScope.of(context).nextFocus();
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: Fab(action: () => debugPrint("djfksl")),
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
