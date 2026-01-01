import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';

/// Network connectivity monitoring service interface.
abstract interface class ConnectivityService {
  /// Returns true if device has internet connection.
  Future<Either<Failure, bool>> isConnected();

  /// Stream of connectivity status changes.
  Stream<bool> get onConnectivityChanged;
}
