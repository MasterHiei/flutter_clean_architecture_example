import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../../auth/domain/entities/user.dart';
import '../../../auth/infrastructure/repositories/auth_repository_impl.dart';

part 'home_notifier.g.dart';

/// Manages home page state including current user and logout.
///
/// Loads user on initialization and handles logout action.
@riverpod
class HomeNotifier extends _$HomeNotifier {
  @override
  Future<User?> build() async {
    final Either<Failure, Option<User>> result = await ref
        .read(authRepositoryProvider)
        .getCurrentUser();
    return result.fold(
      (Failure failure) => throw StateError('Failed to get user: $failure'),
      (Option<User> optionUser) => optionUser.toNullable(),
    );
  }

  /// Logs out the current user and clears stored credentials.
  Future<void> logout() async {
    state = const AsyncLoading();
    final Either<Failure, Unit> result = await ref.read(authRepositoryProvider).logout();
    result.fold(
      (Failure failure) => state = AsyncError(failure, StackTrace.current),
      (_) => state = const AsyncData(null),
    );
  }
}
