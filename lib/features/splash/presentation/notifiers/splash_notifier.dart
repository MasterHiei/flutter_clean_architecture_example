import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/entities/auth_tokens.dart';
import '../../../../core/domain/failures/failure.dart';
import '../../../../core/infrastructure/network/token_manager.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/infrastructure/repositories/auth_repository_impl.dart';

part 'splash_notifier.g.dart';

/// Represents the authentication state during splash screen.
enum SplashAuthState {
  /// Initial state, checking auth status
  loading,

  /// User is authenticated, proceed to home
  authenticated,

  /// User is not authenticated, proceed to login
  unauthenticated,

  /// An error occurred during auth check
  error,
}

/// Notifier for splash screen authentication check.
///
/// Checks stored tokens and refreshes if needed, then determines
/// whether user should go to home or login.
@riverpod
class SplashNotifier extends _$SplashNotifier {
  @override
  Future<SplashAuthState> build() async {
    return _checkAuthAndDetermineRoute();
  }

  Future<SplashAuthState> _checkAuthAndDetermineRoute() async {
    try {
      final TokenManager tokenManager = ref.read(tokenManagerProvider);
      final AuthRepository authRepo = ref.read(authRepositoryProvider);

      // Step 1: Check for stored tokens
      final AuthTokens? tokens = await tokenManager.getTokens();

      if (tokens == null) {
        return SplashAuthState.unauthenticated;
      }

      // Step 2: Check if tokens need refresh
      if (tokens.isExpired || tokens.willExpireIn(const Duration(minutes: 2))) {
        final Either<Failure, AuthTokens> refreshResult = await authRepo.refreshTokens();

        final bool refreshSuccess = refreshResult.fold((failure) => false, (newTokens) => true);

        if (!refreshSuccess) {
          return SplashAuthState.unauthenticated;
        }
      }

      // Step 3: Verify user exists in storage
      final Either<Failure, Option<User>> userResult = await authRepo.getCurrentUser();
      final bool hasUser = userResult.fold((_) => false, (optionUser) => optionUser.isSome());

      return hasUser ? SplashAuthState.authenticated : SplashAuthState.unauthenticated;
    } catch (e) {
      return SplashAuthState.error;
    }
  }

  /// Retry authentication check after error.
  Future<void> retry() async {
    state = const AsyncLoading();
    state = AsyncData(await _checkAuthAndDetermineRoute());
  }
}
