import 'package:fpdart/fpdart.dart';

import '../../../../core/domain/entities/auth_tokens.dart';
import '../../../../core/domain/failures/failure.dart';
import '../entities/user.dart';

/// Authentication repository interface.
abstract interface class AuthRepository {
  Future<Either<Failure, User>> loginWithCredentials({
    required String email,
    required String password,
  });

  Future<Either<Failure, User>> loginWithBiometrics();

  Future<Either<Failure, Unit>> logout();

  Future<Either<Failure, Option<User>>> getCurrentUser();

  /// Refreshes OAuth tokens using stored refresh token.
  Future<Either<Failure, AuthTokens>> refreshTokens();
}
