// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Notifier for splash screen authentication check.
///
/// Checks stored tokens and refreshes if needed, then determines
/// whether user should go to home or login.

@ProviderFor(SplashNotifier)
final splashProvider = SplashNotifierProvider._();

/// Notifier for splash screen authentication check.
///
/// Checks stored tokens and refreshes if needed, then determines
/// whether user should go to home or login.
final class SplashNotifierProvider
    extends $AsyncNotifierProvider<SplashNotifier, SplashAuthState> {
  /// Notifier for splash screen authentication check.
  ///
  /// Checks stored tokens and refreshes if needed, then determines
  /// whether user should go to home or login.
  SplashNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'splashProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$splashNotifierHash();

  @$internal
  @override
  SplashNotifier create() => SplashNotifier();
}

String _$splashNotifierHash() => r'a29a3ef85d985f4c3f07cc2a800c79ec29bb0818';

/// Notifier for splash screen authentication check.
///
/// Checks stored tokens and refreshes if needed, then determines
/// whether user should go to home or login.

abstract class _$SplashNotifier extends $AsyncNotifier<SplashAuthState> {
  FutureOr<SplashAuthState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SplashAuthState>, SplashAuthState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SplashAuthState>, SplashAuthState>,
              AsyncValue<SplashAuthState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
