// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_state_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(authStateController)
final authStateControllerProvider = AuthStateControllerProvider._();

final class AuthStateControllerProvider
    extends
        $FunctionalProvider<
          AuthStateController,
          AuthStateController,
          AuthStateController
        >
    with $Provider<AuthStateController> {
  AuthStateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'authStateControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$authStateControllerHash();

  @$internal
  @override
  $ProviderElement<AuthStateController> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AuthStateController create(Ref ref) {
    return authStateController(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AuthStateController value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AuthStateController>(value),
    );
  }
}

String _$authStateControllerHash() =>
    r'852a457f1f36ac62307a7c203752781842c1815c';
