import 'package:flutter_clean_architecture_example/core/domain/failures/failure.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/entities/user.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_example/features/auth/domain/usecases/login_with_credentials.dart';
import 'package:flutter_clean_architecture_example/features/auth/infrastructure/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_example/features/auth/presentation/notifiers/login_notifier.dart';
import 'package:flutter_clean_architecture_example/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockAppLocalizations extends Mock implements AppLocalizations {}

void main() {
  late MockAuthRepository mockRepository;
  late MockAppLocalizations mockL10n;
  late ProviderContainer container;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockL10n = MockAppLocalizations();
    container = ProviderContainer(
      overrides: [authRepositoryProvider.overrideWithValue(mockRepository)],
    );
    registerFallbackValue(const LoginCredentials(email: '', password: ''));

    // Stub default L10n values
    when(() => mockL10n.errorNetwork).thenReturn('Network connection error');
    when(() => mockL10n.errorServiceUnavailable).thenReturn('Service unavailable');
    when(() => mockL10n.errorInvalidCredentials).thenReturn('Invalid email or password');
    when(() => mockL10n.errorBiometricsUnavailable).thenReturn('Biometrics not available');
    when(() => mockL10n.errorValueMismatch).thenReturn('Values do not match');
    when(() => mockL10n.errorUnexpected).thenReturn('An unexpected error occurred');
    when(() => mockL10n.errorBiometricsHardware).thenReturn('No biometric hardware found');
  });

  tearDown(() {
    container.dispose();
  });

  group('LoginNotifier', () {
    test('Given the notifier is initialized, Then the state should be unauthenticated (null)', () {
      final AsyncValue<User?> state = container.read(loginProvider);
      expect(state, const AsyncData<User?>(null));
    });

    group('loginWithCredentials', () {
      test(
        'Given valid credentials, When login is attempted, Then it should succeed and emit the authenticated User',
        () async {
          const email = 'test@example.com';
          const password = 'password';
          const user = User(id: email, email: email, token: 'token');

          when(
            () => mockRepository.loginWithCredentials(email: email, password: password),
          ).thenAnswer((_) async => right(user));

          final LoginNotifier notifier = container.read(loginProvider.notifier);

          // Act
          await notifier.loginWithCredentials(email, password);

          // Assert
          final AsyncValue<User?> state = container.read(loginProvider);
          expect(state, isA<AsyncData<User?>>());
          expect(state.value, user);
        },
      );

      test(
        'Given invalid credentials or failure, When login is attempted, Then it should fail and emit the appropriate Failure',
        () async {
          const failure = Failure.unauthorized(message: 'Invalid!');

          when(
            () => mockRepository.loginWithCredentials(
              email: any(named: 'email'),
              password: any(named: 'password'),
            ),
          ).thenAnswer((_) async => left(failure));

          final LoginNotifier notifier = container.read(loginProvider.notifier);

          // Act
          await notifier.loginWithCredentials('email', 'password');

          // Assert
          final AsyncValue<User?> state = container.read(loginProvider);
          expect(state, isA<AsyncError<User?>>());
          expect(state.error, failure);
        },
      );
    });

    group('getErrorMessage', () {
      test(
        'Given a specific domain failure (Network, Unauthorized), When mapping to error message, Then it should return a user-friendly instruction',
        () {
          final LoginNotifier notifier = container.read(loginProvider.notifier);

          // Requirement: Show specific message if server provides one, else default
          expect(
            notifier.getErrorMessage(const Failure.server(message: 'Maintenance Mode'), mockL10n),
            'Maintenance Mode',
          );
          expect(notifier.getErrorMessage(const Failure.server(), mockL10n), 'Service unavailable');

          // Requirement: Show network error
          expect(
            notifier.getErrorMessage(const Failure.network(), mockL10n),
            'Network connection error',
          );

          // Requirement: Show auth error
          expect(
            notifier.getErrorMessage(const Failure.unauthorized(), mockL10n),
            'Invalid email or password',
          );

          // Requirement: Device error (biometrics) passes through reason
          // If reason is mapped key
          expect(
            notifier.getErrorMessage(
              const Failure.device(reason: DeviceFailureReason.unavailable),
              mockL10n,
            ),
            'Biometrics not available',
          );
          // If reason is hardware
          expect(
            notifier.getErrorMessage(
              const Failure.device(reason: DeviceFailureReason.noHardware),
              mockL10n,
            ),
            'No biometric hardware found',
          );
        },
      );

      test(
        'Given a technical failure (Cache, Unexpected), When mapping to error message, Then it should return a safe generic message to avoid exposing internals',
        () {
          final LoginNotifier notifier = container.read(loginProvider.notifier);

          // Requirement: Technical errors should not expose internals to user
          const genericError = 'An unexpected error occurred';

          expect(notifier.getErrorMessage(const Failure.cache(), mockL10n), genericError);
          expect(
            notifier.getErrorMessage(const Failure.notFound(resource: 'User'), mockL10n),
            genericError,
          );
          expect(notifier.getErrorMessage(const Failure.unexpected(), mockL10n), genericError);
        },
      );
    });
  });
}
