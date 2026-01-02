import 'package:auto_route/auto_route.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../core/domain/failures/failure.dart';
import '../../features/auth/domain/entities/user.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/infrastructure/repositories/auth_repository_impl.dart';
import '../app_router.dart';

part 'auth_guard.g.dart';

@riverpod
Future<bool> isAuthenticated(Ref ref) async {
  final AuthRepository repo = ref.read(authRepositoryProvider);
  final Either<Failure, Option<User>> result = await repo.getCurrentUser();
  return result.fold((_) => false, (user) => user.isSome());
}

/// Route guard that protects routes requiring authentication.
///
/// Redirects to login page if user is not authenticated.
class AuthGuard extends AutoRouteGuard {
  AuthGuard(this._ref);
  final Ref _ref;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final Either<Failure, Option<User>> result = await _ref
        .read(authRepositoryProvider)
        .getCurrentUser();
    final bool isLoggedIn = result.fold((_) => false, (user) => user.isSome());
    if (isLoggedIn) {
      resolver.next();
    } else {
      // Redirect to login and abort current navigation
      await router.push(const LoginRoute());
      resolver.next(false);
    }
  }
}

/// Guard that redirects authenticated users away from login page.
///
/// If user is already logged in, redirects to home page.
class GuestGuard extends AutoRouteGuard {
  GuestGuard(this._ref);
  final Ref _ref;

  @override
  Future<void> onNavigation(NavigationResolver resolver, StackRouter router) async {
    final Either<Failure, Option<User>> result = await _ref
        .read(authRepositoryProvider)
        .getCurrentUser();
    final bool isLoggedIn = result.fold((_) => false, (user) => user.isSome());
    if (isLoggedIn) {
      // Redirect to home and abort current navigation
      await router.push(const HomeRoute());
      resolver.next(false);
    } else {
      resolver.next();
    }
  }
}
