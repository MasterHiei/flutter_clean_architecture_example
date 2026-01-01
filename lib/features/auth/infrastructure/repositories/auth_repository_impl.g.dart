// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mockAuthDataSource)
final mockAuthDataSourceProvider = MockAuthDataSourceProvider._();

final class MockAuthDataSourceProvider
    extends
        $FunctionalProvider<
          MockAuthDataSource,
          MockAuthDataSource,
          MockAuthDataSource
        >
    with $Provider<MockAuthDataSource> {
  MockAuthDataSourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mockAuthDataSourceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mockAuthDataSourceHash();

  @$internal
  @override
  $ProviderElement<MockAuthDataSource> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MockAuthDataSource create(Ref ref) {
    return mockAuthDataSource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MockAuthDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MockAuthDataSource>(value),
    );
  }
}

String _$mockAuthDataSourceHash() =>
    r'0e04f7bbc822cccd650f4d5ac8ca9eb5c0c87e36';

@ProviderFor(authRepository)
final authRepositoryProvider = AuthRepositoryProvider._();

final class AuthRepositoryProvider
    extends $FunctionalProvider<AuthRepository, AuthRepository, AuthRepository>
    with $Provider<AuthRepository> {
  AuthRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authRepositoryHash();

  @$internal
  @override
  $ProviderElement<AuthRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  AuthRepository create(Ref ref) {
    return authRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthRepository>(value),
    );
  }
}

String _$authRepositoryHash() => r'77e84c9d796b5b6a2d0d2f3566cc269373518288';
