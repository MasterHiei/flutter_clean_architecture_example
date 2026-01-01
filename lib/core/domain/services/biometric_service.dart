import 'package:fpdart/fpdart.dart';

import '../failures/failure.dart';

/// Biometric authentication service interface.
abstract interface class BiometricService {
  /// Returns true if device supports biometric authentication.
  Future<Either<Failure, bool>> isAvailable();

  /// Attempts biometric authentication. Returns true if successful.
  Future<Either<Failure, bool>> authenticate({required String reason});
}
