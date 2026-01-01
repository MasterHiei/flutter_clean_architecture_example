// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'password_visibility_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(PasswordVisibilityNotifier)
final passwordVisibilityProvider = PasswordVisibilityNotifierProvider._();

final class PasswordVisibilityNotifierProvider
    extends $NotifierProvider<PasswordVisibilityNotifier, bool> {
  PasswordVisibilityNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'passwordVisibilityProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$passwordVisibilityNotifierHash();

  @$internal
  @override
  PasswordVisibilityNotifier create() => PasswordVisibilityNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$passwordVisibilityNotifierHash() =>
    r'725b206ccb8a52e0bd00cc7b06f74e6fc3c47240';

abstract class _$PasswordVisibilityNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
