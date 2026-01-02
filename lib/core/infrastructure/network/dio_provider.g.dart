// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dio_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Provides configured [Dio] instance for network requests.
///
/// The [AuthInterceptor] is configured with:
/// - Token manager for header injection
/// - Refresh function for 401 handling
/// - Auth state controller for expired event broadcasting

@ProviderFor(dio)
final dioProvider = DioProvider._();

/// Provides configured [Dio] instance for network requests.
///
/// The [AuthInterceptor] is configured with:
/// - Token manager for header injection
/// - Refresh function for 401 handling
/// - Auth state controller for expired event broadcasting

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  /// Provides configured [Dio] instance for network requests.
  ///
  /// The [AuthInterceptor] is configured with:
  /// - Token manager for header injection
  /// - Refresh function for 401 handling
  /// - Auth state controller for expired event broadcasting
  DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'8185532bf5f302dbe0205020da7987dba4d6445c';
