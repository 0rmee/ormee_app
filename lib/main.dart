import 'package:flutter/material.dart';
import 'package:ormee_app/feature/lecture/detail/presentation/pages/lecture_detail.dart';
import 'package:ormee_app/app/router/app_router.dart';
import 'package:ormee_app/core/init/app_init.dart';
import 'app/app.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('ko_KR', null);
  await appInit(AppRouter.router);
  setupDependencies();
  runApp(const OrmeeApp());
}
