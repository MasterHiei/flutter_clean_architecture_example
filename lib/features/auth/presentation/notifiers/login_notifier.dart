import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/domain/failures/failure.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/login_with_biometrics.dart';
import '../../domain/usecases/login_with_credentials.dart';
import '../../infrastructure/repositories/auth_repository_impl.dart';

part 'login_notifier.g.dart';

@riverpod
class LoginNotifier extends _$LoginNotifier {
  @override
  AsyncValue<User?> build() => const AsyncData(null);

  Future<void> loginWithCredentials(String email, String password) async {
    state = const AsyncLoading();
    final useCase = LoginWithCredentials(ref.read(authRepositoryProvider));
    final Either<Failure, User> result = await useCase(
      LoginCredentials(email: email, password: password),
    );
    state = result.fold((failure) => AsyncError(failure, StackTrace.current), AsyncData.new);
  }

  Future<void> loginWithBiometrics() async {
    state = const AsyncLoading();
    final useCase = LoginWithBiometrics(ref.read(authRepositoryProvider));
    final Either<Failure, User> result = await useCase();
    state = result.fold((failure) => AsyncError(failure, StackTrace.current), AsyncData.new);
  }

  String getErrorMessage(Failure failure, AppLocalizations l10n) => failure.map(
    network: (_) => l10n.errorNetwork,
    server: (f) => f.message ?? l10n.errorServiceUnavailable,
    unauthorized: (_) => l10n.errorInvalidCredentials,
    device: (f) => switch (f.reason) {
      DeviceFailureReason.unavailable => l10n.errorBiometricsUnavailable,
      DeviceFailureReason.noHardware => l10n.errorBiometricsHardware,
      DeviceFailureReason.other => l10n.errorUnexpected,
    },
    // Validation should be handled by Form validation
    validation: (_) => l10n.errorValueMismatch,
    // Technical failures
    cache: (_) => l10n.errorUnexpected,
    notFound: (_) => l10n.errorUnexpected,
    unexpected: (_) => l10n.errorUnexpected,
  );
}
