import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:fpdart/fpdart.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/failures/failure.dart';
import '../../domain/services/connectivity_service.dart';

part 'connectivity_service_impl.g.dart';

/// Implementation of [ConnectivityService] using connectivity_plus.
final class ConnectivityServiceImpl implements ConnectivityService {
  ConnectivityServiceImpl([Connectivity? connectivity])
    : _connectivity = connectivity ?? Connectivity();

  final Connectivity _connectivity;

  @override
  Future<Either<Failure, bool>> isConnected() async {
    try {
      final List<ConnectivityResult> results = await _connectivity.checkConnectivity();
      final bool connected = results.any((r) => r != ConnectivityResult.none);
      return right(connected);
    } catch (e, st) {
      return left(Failure.unexpected(error: e, stackTrace: st));
    }
  }

  @override
  Stream<bool> get onConnectivityChanged => _connectivity.onConnectivityChanged.map(
    (results) => results.any((r) => r != ConnectivityResult.none),
  );
}

@Riverpod(keepAlive: true)
ConnectivityService connectivityService(Ref ref) => ConnectivityServiceImpl();
