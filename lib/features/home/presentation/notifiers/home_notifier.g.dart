// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_notifier.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Manages home page state including current user and logout.
///
/// Loads user on initialization and handles logout action.

@ProviderFor(HomeNotifier)
final homeProvider = HomeNotifierProvider._();

/// Manages home page state including current user and logout.
///
/// Loads user on initialization and handles logout action.
final class HomeNotifierProvider
    extends $AsyncNotifierProvider<HomeNotifier, User?> {
  /// Manages home page state including current user and logout.
  ///
  /// Loads user on initialization and handles logout action.
  HomeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'homeProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$homeNotifierHash();

  @$internal
  @override
  HomeNotifier create() => HomeNotifier();
}

String _$homeNotifierHash() => r'2c0075a5aa14acdcb3c86fdd569b1d3ed15978b9';

/// Manages home page state including current user and logout.
///
/// Loads user on initialization and handles logout action.

abstract class _$HomeNotifier extends $AsyncNotifier<User?> {
  FutureOr<User?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<User?>, User?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<User?>, User?>,
              AsyncValue<User?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
