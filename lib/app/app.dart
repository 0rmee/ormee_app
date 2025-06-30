import 'package:flutter/material.dart';
import 'router/app_router.dart';

class OrmeeApp extends StatelessWidget {
  const OrmeeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Ormee App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
