import 'package:auto_route/auto_route.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // TODO: Add routes as features are implemented
    // AutoRoute(page: LoginRoute.page, initial: true),
    // AutoRoute(page: HomeRoute.page),
  ];
}
