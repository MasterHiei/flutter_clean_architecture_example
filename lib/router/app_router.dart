import 'package:auto_route/auto_route.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/auth/presentation/pages/login_page.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/splash/presentation/pages/splash_page.dart';
import 'guards/auth_guard.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  AppRouter(this._ref);
  final Ref _ref;

  @override
  List<AutoRoute> get routes => [
    // Splash as initial - handles auth check
    AutoRoute(page: SplashRoute.page, initial: true),

    // Main routes
    AutoRoute(page: LoginRoute.page, guards: [GuestGuard(_ref)]),
    AutoRoute(page: HomeRoute.page, guards: [AuthGuard(_ref)]),
  ];
}
