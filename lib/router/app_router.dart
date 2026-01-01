import 'package:auto_route/auto_route.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Splash as initial - handles auth check
    AutoRoute(page: SplashRoute.page, initial: true),
    // Main routes (navigation controlled by splash/notifiers)
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: HomeRoute.page),
  ];
}
