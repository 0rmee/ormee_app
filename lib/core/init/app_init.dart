import 'package:ormee_app/core/network/api_client.dart';
import 'package:ormee_app/feature/auth/token/update.dart';
import 'package:go_router/go_router.dart';

Future<void> appInit(GoRouter router) async {
  final accessToken = await AuthStorage.getAccessToken();
  final refreshToken = await AuthStorage.getRefreshToken();

  if (accessToken != null && refreshToken != null) {
    ApiClient.instance.initialize(
      accessToken: accessToken,
      refreshToken: refreshToken,
      onLogout: () async {
        await AuthStorage.clear();
        router.go('/login');
      },
    );
  } else {
    router.go('/login');
  }
}
